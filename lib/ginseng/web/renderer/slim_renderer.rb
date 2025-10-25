require 'slim'

module Ginseng
  module Web
    class SlimRenderer < HTMLRenderer
      include Package

      attr_reader :params

      def initialize(template = nil)
        Slim::Engine.set_options(
          shortcut: shortcuts,
          pretty: environment_class.development?,
        )
        @config = config_class.instance
        @logger = logger_class.new
        @status = 200
        @params = {}.with_indifferent_access
        self.template = template if template
        super()
      end

      def template=(name)
        path = create_path(name)
        raise Ginseng::RenderError, "Template '#{name}' not found" unless File.exist?(path)
        @slim = Slim::Template.new(path)
      end

      def []=(key, value)
        @params[key] = value
      end

      def to_s
        raise Ginseng::RenderError, 'Template undefined' unless @slim
        return @slim.render({}, assign_values)
      end

      def self.render(name, values = {})
        slim = SlimRenderer.new(name)
        slim.params.merge!(values)
        return slim.to_s
      rescue Ginseng::RenderError
        return nil
      end

      private

      def create_path(name)
        return File.join(environment_class.dir, 'views', "#{name.sub(/\.slim$/i, '')}.slim")
      end

      def shortcuts
        return {
          '#' => {tag: 'div', attr: 'id'},
          '.' => {tag: 'div', attr: 'class'},
          '^' => {tag: 'script', attr: 'type'},
        }
      end

      def assign_values
        return {
          params:,
          slim: SlimRenderer,
        }
      end
    end
  end
end
