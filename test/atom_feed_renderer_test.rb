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
        assert_equal(@renderer.to_s.each_line.first.chomp, '<?xml version="1.0" encoding="UTF-8"?>')
      end
    end
  end
end
