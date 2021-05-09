require 'rss'
require 'time'

module Ginseng
  module Web
    class FeedRenderer < Renderer
      include Package
      attr_reader :entries, :channel

      def initialize(channel = {})
        super()
        @channel = {
          title: package_class.name,
          link: package_class.url,
          description: package_class.description,
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
        entries.push(values.to_h)
        @feed = nil
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
