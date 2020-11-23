module Ginseng
  module Web
    class SlimRendererTest < Test::Unit::TestCase
      def setup
        @renderer = SlimRenderer.new
        @renderer.template = 'test'
      end

      def test_type
        assert_equal(@renderer.type, 'text/html; charset=UTF-8')
      end

      def test_status
        assert_equal(@renderer.status, 200)
        @renderer.status = 404
        assert_equal(@renderer.status, 404)
      end

      def test_params
        assert_kind_of(Hash, @renderer.params)
      end

      def test_to_s
        assert_equal(@renderer.to_s, "<!DOCTYPE html>\n<html>\n  <head>\n    <title>SlimRenderer test</title>\n  </head>\n  <body>\n    <div>\n      SlimRenderer\n    </div>\n  </body>\n</html>")
      end
    end
  end
end
