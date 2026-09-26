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

      # 🔴🔴 **`enclosure.url` を内部アドレスへ向けても、既定では接続しない (#138)。**
      # ⚠⚠ 判定の単体テストだけでは「`fetch_image` が判定を通しているか」は測れないので、
      # ローカルに実際のサーバーを立て、**接続が来たかどうか**で測る。
      def test_enclosure_to_an_internal_address_is_not_fetched
        with_server do |url, hits|
          renderer = RSS20FeedRenderer.new
          renderer.push(title: 'x', link: 'https://example.com/', enclosure: {url:})
          renderer.to_s

          assert_equal(0, hits.size, '内部アドレスへ接続しないこと')
        end
      end

      # ⚠ **差し替えの口が効くこと。** nil を返すと検証しない（3.0.2 までの挙動）。
      # ⚠ これが緑でないと、上のテストは「そもそも取りにいっていない」でも緑になる。
      def test_image_host_validator_can_be_replaced
        with_server do |url, hits|
          renderer = UncheckedRenderer.new
          renderer.push(title: 'x', link: 'https://example.com/', enclosure: {url:})

          assert_includes(renderer.to_s, 'image/png')
          assert_equal(1, hits.size)
        end
      end

      class UncheckedRenderer < RSS20FeedRenderer
        private

        def image_host_validator
          return nil
        end
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

      private

      # 127.0.0.1 の空きポートで、来た要求を記録して 200 を返すサーバー。
      def with_server
        server = TCPServer.new('127.0.0.1', 0)
        hits = Queue.new
        thread = Thread.new do
          loop do
            client = server.accept
            hits.push(client.gets)
            client.write("HTTP/1.1 200 OK\r\nContent-Type: image/png\r\nContent-Length: 0\r\nConnection: close\r\n\r\n")
            client.close
          end
        end
        yield "http://127.0.0.1:#{server.addr[1]}/image.png", hits
      ensure
        thread&.kill
        server&.close
      end
    end
  end
end
