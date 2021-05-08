module Ginseng
  module Web
    class RSS20FeedRendererTest < Test::Unit::TestCase
      def setup
        @renderer = RSS20FeedRenderer.new
      end

      def test_type
        assert_equal(@renderer.type, 'application/rss+xml; charset=UTF-8')
      end

      def test_status
        assert_equal(@renderer.status, 200)
        @renderer.status = 404
        assert_equal(@renderer.status, 404)
      end

      def test_to_s
        assert(@renderer.to_s.include?('<rss version="2.0"'))
      end
    end
  end
end
