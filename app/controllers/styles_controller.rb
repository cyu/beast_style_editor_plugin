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

  def update
    (params[:options] || {}).each_pair do |name, value|
      opt = @style.get_option(name)
      opt.value = value
      opt.save!
    end
    @style.update_attributes! params[:style]
    @style.generate_css(edited_stylesheet_file)
    
    respond_to do |format|
      format.html { redirect_to styles_path }
      format.xml  { head 200 }
    end
  end

  protected
  
    def find_or_initialize_style
      @style = params[:id] ? Style.find(params[:id]) : Style.new
    end
    
    def edited_stylesheet_file
      File.join(RAILS_ROOT, 'public', 'stylesheets', '_display.css')
    end

end
