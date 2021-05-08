module Ginseng
  module Web
    class RSS20FeedRenderer < FeedRenderer
      def type
        return 'application/rss+xml; charset=UTF-8'
      end

      def feed_type
        return 'rss2.0'
      end
    end
  end
end
