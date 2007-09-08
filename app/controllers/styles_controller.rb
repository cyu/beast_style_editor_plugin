class StylesController < ApplicationController

  alias :authorized? :admin?

  before_filter :login_required
  before_filter :find_or_initialize_style, :except => :index

  def index
    respond_to do |format|
      format.html do
        @styles = Style.paginate :page => params[:page], :per_page => 50, :order => "name", :conditions => Style.build_search_conditions(params[:q])
        @style_count = Style.count
      end
      format.xml do
        @styles = Style.search(params[:q], :limit => 25)
        render :xml => @styles.to_xml
      end
    end
  end

  def create
    save_style_options
    @style.attributes = params[:style]
    @style.save!
    respond_to do |format|
      format.html { redirect_to styles_path }
      format.xml { head :created, :location => formatted_style_url(:id => @style, :format => :xml) }
    end
  end

  def update
    save_style_options
    @style.update_attributes! params[:style]
    generate_css

    respond_to do |format|
      format.html { redirect_to styles_path }
      format.xml  { head 200 }
    end
  end
  
  def activate
    unless @style.active?
      Style.update_all('active = 0', {:active => true})
      @style.active = true
      @style.save!
      generate_css
    end
    redirect_to styles_path
  rescue ActiveRecord::RecordInvalid
    redirect_to styles_path
  end

  def options
    @style.template_name = params[:style][:template_name]
    render :partial => 'form_options', :layout => false
  end

  protected

    def find_or_initialize_style
      @style = params[:id] ? Style.find(params[:id]) : Style.new(:template_name => 'default')
    end

    def edited_stylesheet_file
      File.join(RAILS_ROOT, 'public', 'stylesheets', '_display.css')
    end

    def save_style_options
      (params[:options] || {}).each_pair do |name, value|
        opt = @style.get_option(name)
        opt.value = value
        opt.save!
      end
    end

    def generate_css
      @style.generate_css(edited_stylesheet_file) if @style.active?
    end

end
