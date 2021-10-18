module Ginseng
  module Web
    class RSS20FeedRenderer < FeedRenderer
      def initialize(channel = {})
        super
        @http = HTTP.new
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
          channel.each {|k, v| maker.channel.send("#{k}=", v)}
          entries.each do |entry|
            maker.items.new_item do |item|
              if info = fetch_image(entry.dig(:enclosure, :url))
                info.slice(:type, :length, :url).each {|k, v| item.enclosure.send("#{k}=", v)}
              end
              entry.except(:enclosure).each {|k, v| item.send("#{k}=", v)}
            end
          rescue => e
            @logger.error(error: e, entry: entry)
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
