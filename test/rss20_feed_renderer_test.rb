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
    end
  end
end
