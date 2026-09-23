module Ginseng
  module Web
    class RSS20FeedRendererTest < Test::Unit::TestCase
      def setup
        @renderer = RSS20FeedRenderer.new
      end

      def test_type
        assert_equal('application/rss+xml; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404

        assert_equal(404, @renderer.status)
      end

      def test_to_s
        assert_includes(@renderer.to_s, '<rss version="2.0"')
      end

      # ⚠⚠ **既定を固定する (#135)。** `http_class` は `Ginseng::Package` にも
      # あって `Ginseng::HTTP` を返すので、**`Ginseng::Package` を include して
      # 済ませると既定が黙って `Ginseng::Web::HTTP` から落ちる**。
      # ⚠ どこにも定義しない場合は黙らず `NameError` になる（実測で 5 件赤）。
      def test_http_class_default
        assert_equal(HTTP, Object.new.extend(Package).http_class)
        assert_instance_of(HTTP, @renderer.instance_variable_get(:@http))
      end

      # 🔴🔴 **利用側が `http_class` を差し替えた形で測る (#135)。**
      # ⚠ 既定では直書きの `HTTP` と `http_class` が同じクラスに解決されるので、
      # **素の renderer を見ているだけでは直書きに気づけない**。
      # ⚠ `mulukhiya-toot-proxy` の `RSS20FeedRenderer` / `MediaFeedRenderer` と
      # 同じ形 — 自前の HTTP と、それを返す `Package` を持つ。
      def test_http_class_is_honored
        assert_instance_of(StubHTTP, StubRenderer.new.instance_variable_get(:@http))
      end

      class StubHTTP < HTTP; end

      module StubPackage
        include Package

        def http_class
          return StubHTTP
        end
      end

      class StubRenderer < RSS20FeedRenderer
        include StubPackage
      end
    end
  end
end
