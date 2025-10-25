module Ginseng
  module Web
    class ScriptRenderer < Renderer
      include Package

      attr_reader :name

      def name=(name)
        @name = name.sub(/\.js$/, '')
        raise Ginseng::RenderError, "Script '#{name}' not found." unless File.exist?(path)
      end

      def path
        return File.join(dir, "#{name}.js")
      end

      def dir
        return File.join(environment_class.dir, 'public')
      end

      def type
        return 'text/javascript;charset=UTF-8'
      end

      def to_s
        return File.read(path)
      end
    end
  end
end
