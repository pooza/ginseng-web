require 'sassc'

module Ginseng
  module Web
    class CSSRenderer < Renderer
      include Package

      def template=(name)
        path = File.join(environment_class.dir, "views/#{name}.sass")
        raise RenderError, "Template file #{name} not found" unless File.exist?(path)
        @template = SassC::Engine.new(File.read(path), {syntax: :sass, style: :compressed})
      end

      def type
        return 'text/css; charset=UTF-8'
      end

      def to_s
        raise RenderError, 'Template file undefined' unless @template
        return @template.render
      end
    end
  end
end
