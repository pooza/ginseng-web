module Ginseng
  module Web
    class CSSRendererTest < Test::Unit::TestCase
      def setup
        @renderer = CSSRenderer.new
        @renderer.template = 'test'
      end

      def test_type
        assert_equal('text/css; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404

        assert_equal(404, @renderer.status)
      end

      def test_to_s
        assert_equal('body{width:800px}', @renderer.to_s.chomp)
      end
    end
  end
end
