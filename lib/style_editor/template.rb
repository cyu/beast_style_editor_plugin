module StyleEditor
  class Template
    cattr_accessor :template_paths
    attr_accessor :name
    
    @@template_paths = [ File.join(Beast::Plugins::StyleEditor.plugin_path, 'templates') ]
    
    def self.load(name)
      config = YAML.load_file(find_template_file(name, 'template.yml'))
      Template.new(name, config)
    end
    
    def self.available_templates(path = nil)
      if path
        Dir.glob(path + "/*").collect do |f|
          File.exist?(File.join(f, 'template.yml')) ? File.basename(f) : nil
        end.compact
      else
        template_paths.collect { |p| available_templates(p) }.flatten
      end
    end
    
    def initialize(name, config)
      @name = name
      @config = config
    end
    
    def options
      @config['options'] || []
    end
    
    def render(style_options)
      styles = style_options.inject({}) { |m, o| m[o.name] = o.evaluated_value; m }
      ERB.new(template_text).result(binding)
    end
    
    protected
    
      def template_text
        File.read(self.class.find_template_file(name, "#{name}.css.erb"))
      end
      
      def self.find_template_file(*args)
        path = template_paths.find { |temp| File.exist?(File.join(temp, *args)); }
        File.join(path, *args)
      end
  end
end