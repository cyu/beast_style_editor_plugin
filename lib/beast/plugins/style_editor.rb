module Beast
  module Plugins

    class StyleEditor < Beast::Plugin
      author 'Calvin Yu - boardista.com'
      version '0001'
      homepage 'http://boardista.com'
      notes 'Style Editing Support'

      [ 'controllers', 'helpers', 'models' ].each do |dir|
        path = File.join(plugin_path, 'app', dir)
        Dependencies.load_paths << File.expand_path(path) if File.exist?(path)
      end
      
      def initialize
        super
      end

    end # end StyleEditor class

  end
end
