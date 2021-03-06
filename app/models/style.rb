class Style < ActiveRecord::Base

  has_many :options, :table_name => 'style_options', :class_name => 'StyleOption'
  validates_presence_of :name, :template_name
  attr_protected :active

  def self.find_active
    find(:first, :conditions => {:active => true}) ||
        Style.create!(:name => 'Default Style', :template_name => 'default', :active => true) 
  end

  def self.search(query, options = {})
    with_scope :find => { :conditions => build_search_conditions(query) } do
      find :all, options
    end
  end

  def self.build_search_conditions(query)
    query && ['LOWER(name) LIKE :q', {:q => "%#{query}%"}]
  end

  def template_options
    template.options.collect do |option_config|
      option = get_option(option_config['name'])
      option.config = option_config
      option
    end
  end
  
  def get_option(name)
    options.detect { |opt| opt.name == name } || self.options.build(:name => name)
  end
  
  def generate_css(file=nil)
    FileUtils.mkdir_p(File.dirname(file)) if file && !File.exist?(File.dirname(file))
    
    s = template.render(template_options)
    if file
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') { |io| io.write(s) }
    end
    s
  end

  # Activate this style.  Will deactivate any activated styles
  def activate!
    Style.update_all("active = #{connection.quoted_false}", {:active => true})
    self.active = true
    self.save!
  end

  protected

    def template
      @template ||= StyleEditor::Template.load(template_name)
    end
    
end
