module Ginseng
  module Web
    class AtomFeedRendererTest < Test::Unit::TestCase
      def setup
        @renderer = AtomFeedRenderer.new
      end

      def test_type
        assert_equal(@renderer.type, 'application/atom+xml; charset=UTF-8')
      end

      def test_status
        assert_equal(@renderer.status, 200)
        @renderer.status = 404
        assert_equal(@renderer.status, 404)
      end

      def test_to_s
        assert(@renderer.to_s.include?('<feed xmlns="http://www.w3.org/2005/Atom"'))
      end
    end
  end
end
