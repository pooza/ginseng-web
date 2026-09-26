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

      # テンプレートの断片（`== slim.render 'fragment/header'`）を描く。
      #
      # 🔴🔴 **クラスを直に書かない (#137)。** `SlimRenderer.new` は字面どおり
      # `Ginseng::Web::SlimRenderer` になり、`create_path` が **gem の `views/`** を探す。
      # ⚠⚠ 利用側のテンプレートは見つからず、**ページは 200 のままフラグメントだけが
      # 黙って消えていた**（`mulukhiya-toot-proxy` はこのメソッドを丸ごと写して回避していた）。
      # `new` ならサブクラスから呼べばそのサブクラスになる。
      def self.render(name, values = {})
        return new.render_fragment(name, values)
      end

      # `render` の本体。⚠ **失敗は nil に倒すが、ログは残す (#137)** — 残さないと
      # 消えたフラグメントに誰も気づけない。
      def render_fragment(name, values = {})
        self.template = name
        params.merge!(values)
        return to_s
      rescue Ginseng::RenderError => e
        @logger.error(error: e, template: name)
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
          # ⚠ 直に書かない (#137)。テンプレートの中の `slim.render` も、利用側のクラスで描く。
          slim: self.class,
        }
      end
    end
  end
end
