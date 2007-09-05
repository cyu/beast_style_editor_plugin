module StyleEditor
  class Template
    attr_accessor :name
    
    def self.load(name)
      config = YAML.load_file(templates_path(name, 'template.yml'))
      Template.new(name, config)
    end
    
    def self.templates_path(*args)
      path = [ Beast::Plugins::StyleEditor.plugin_path, 'templates' ]
      path.push(*args) if args && !args.empty?
      File.join(*path)
    end
    
    def self.available_templates
      Dir.glob(templates_path + "/*").collect do |f|
        File.exist?(File.join(f, 'template.yml')) ? File.basename(f) : nil
      end.compact
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
      ERB.new(template).result(binding)
    end
    
    protected
    
      def template
        File.read(self.class.templates_path(name, "#{name}.css.erb"))
      end
  end
end