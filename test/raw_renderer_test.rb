module Ginseng
  module Web
    class RawRendererTest < Test::Unit::TestCase
      def setup
        @renderer = RawRenderer.new
      end

      def test_type
        assert_nil(@renderer.type)
        @renderer.type = 'text/css; charset=UTF-8'
        assert_equal('text/css; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404
        assert_equal(404, @renderer.status)
      end

      def test_body
        assert_nil(@renderer.body)
        @renderer.body = '{}'
        assert_equal('{}', @renderer.body)
      end
    end
  end
end
