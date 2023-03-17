module Ginseng
  module Web
    class SlimRendererTest < Test::Unit::TestCase
      def setup
        @renderer = SlimRenderer.new
        @renderer.template = 'test'
      end

      def test_type
        assert_equal('text/html; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404

        assert_equal(404, @renderer.status)
      end

      def test_params
        assert_kind_of(Hash, @renderer.params)
      end

      def test_to_s
        assert_equal("<!DOCTYPE html>\n<html>\n  <head>\n    <title>SlimRenderer test</title>\n  </head>\n  <body>\n    <div>\n      SlimRenderer\n    </div>\n  </body>\n</html>", @renderer.to_s)
      end
    end
  end
end
