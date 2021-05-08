module Ginseng
  module Web
    class AtomFeedRenderer < FeedRenderer
      def type
        return 'application/atom+xml; charset=UTF-8'
      end

      def feed_type
        return 'atom'
      end
    end
  end
end
