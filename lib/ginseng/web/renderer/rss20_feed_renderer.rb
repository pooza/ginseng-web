module Ginseng
  module Web
    class RSS20FeedRenderer < FeedRenderer
      def initialize(channel = {})
        super
        # ⚠⚠ **`HTTP` と直に書かない (#135)。** 字面どおり `Ginseng::Web::HTTP` に
        # 解決されるので、**利用側が `http_class` を差し替えても黙って無視される**。
        # 🔴 実測で `mulukhiya-toot-proxy` のフィード描画は、**利用側が足したマスク
        # （`auth` / `endpoint` / `publickey`）が掛からず**、`cert_file` も gem 同梱の
        # ものを見ていた（`Ginseng::HTTP#initialize` が `logger_class` /
        # `config_class` / `environment_class` から読むため。
        # pooza/ginseng-core#548 と同じ型）。
        # ⚠ **変わらないもの 2 つ**（リリース前レビューで実測）— 再送上限は下の行で
        # 無条件に上書きする／syslog のプログラム名は**プロセスに 1 つ**で、
        # 最初に開いた名前に固定される（`Syslog::Logger` の `@@syslog ||=`）。
        @http = http_class.new
        @http.retry_limit = 2
        @http.base_uri = channel[:link]
      end

      def type
        return 'application/rss+xml; charset=UTF-8'
      end

      def feed
        @feed ||= RSS::Maker.make('rss2.0') do |maker|
          maker.items.do_sort = true
          maker.channel.id = channel[:link]
          channel.each {|k, v| maker.channel.send(:"#{k}=", v)}
          entries.each do |entry|
            maker.items.new_item do |item|
              if info = fetch_image(entry.dig(:enclosure, :url))
                info.slice(:type, :length, :url).each {|k, v| item.enclosure.send(:"#{k}=", v)}
              end
              entry.except(:enclosure).each {|k, v| item.send(:"#{k}=", v)}
            end
          rescue => e
            @logger.error(error: e, entry:)
          end
        end
        return @feed
      end

      private

      def fetch_image(uri)
        return nil unless uri
        response = @http.get(uri)
        return {
          url: uri.to_s,
          type: response.headers['content-type'],
          length: response.headers['content-length'],
        }
      rescue => e
        @logger.error(error: e, uri: uri.to_s)
        return nil
      end
    end
  end
end
