require 'rss'

module Ginseng
  module Web
    class FeedRenderer < Renderer
      include Package
      attr_reader :entries, :channel

      def initialize(channel = {})
        super()
        channel.deep_symbolize_keys!
        @channel = {
          title: channel[:title] || package_class.name,
          link: channel[:link] || package_class.url,
          description: channel[:description] || package_class.description,
          author: package_class.authors.first,
          date: Time.now,
          generator: package_class.user_agent,
        }
        @entries = []
      end

      def type
        raise ImplementError, "'#{__method__}' not implemented"
      end

      def push(values)
        entries.push(values.to_h.deep_symbolize_keys)
        @feed = nil
      end

      def entries=(entries)
        entries.each {|v| push(v)}
      end

      def feed
        raise ImplementError, "'#{__method__}' not implemented"
      end

      def to_s
        return feed.to_s
      end
    end
  end
end
