module Beast
  module Plugins

    class StyleEditor < Beast::Plugin
      author 'Calvin Yu - boardista.com'
      version '0002'
      homepage 'http://boardista.com'
      notes 'Style Editing Support'

      %w( controllers helpers models ).each do |dir|
        path = File.expand_path(File.join(plugin_path, 'app', dir))
        if File.exist?(path) && !Dependencies.load_paths.include?(path)
          Dependencies.load_paths << path
        end
      end

      route :style_options, 'styles/options/:id', :controller => 'styles', :action => 'options'
      route :activate_style, 'styles/activate/:id', :controller => 'styles', :action => 'activate'
      route :resources, 'styles'

      def initialize
        super
        ApplicationController.prepend_view_path File.join(StyleEditor::plugin_path, 'app', 'views')
      end # end of initialize
      
      def install
        super
        FileUtil.copy(File.join(RAILS_ROOT, 'public', 'stylesheets', 'display.css'),
            File.join(RAILS_ROOT, 'public', 'stylesheets', '_display.css'))
      end

      class Schema < ActiveRecord::Migration    
        def self.install
          create_table :style_options do |t|
            t.string :name
            t.string :value
            t.integer :style_id
          end

          create_table :styles do |t|
            t.string :name
            t.string :template_name
            t.boolean :active
            t.timestamps 
          end
        end
      
        def self.uninstall
          drop_table :styles
          drop_table :style_options
        end
      end # end Schema class

    end # end StyleEditor class

  end
end
