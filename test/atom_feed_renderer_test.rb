module Ginseng
  module Web
    class AtomFeedRendererTest < Test::Unit::TestCase
      def setup
        @renderer = AtomFeedRenderer.new
      end

      def test_type
        assert_equal('application/atom+xml; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404
        assert_equal(404, @renderer.status)
      end

      def test_to_s
        assert_includes(@renderer.to_s, '<feed xmlns="http://www.w3.org/2005/Atom"')
      end
    end
  end
end
