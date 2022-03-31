module Ginseng
  module Web
    class ScriptRendererTest < Test::Unit::TestCase
      def setup
        @renderer = ScriptRenderer.new
        @renderer.name = 'activity_indicator'
      end

      def test_type
        assert_equal('text/javascript;charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404
        assert_equal(404, @renderer.status)
      end

      def test_to_s
        assert(@renderer.to_s, 'class ActivityIndicator')
      end
    end
  end
end
