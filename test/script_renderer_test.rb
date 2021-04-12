module Ginseng
  module Web
    class ScriptRendererTest < Test::Unit::TestCase
      def setup
        @renderer = ScriptRenderer.new
        @renderer.name = 'activity_indicator'
      end

      def test_type
        assert_equal(@renderer.type, 'text/javascript;charset=UTF-8')
      end

      def test_status
        assert_equal(@renderer.status, 200)
        @renderer.status = 404
        assert_equal(@renderer.status, 404)
      end

      def test_to_s
        assert(@renderer.to_s, 'class ActivityIndicator')
        assert_equal(@renderer.to_s.split("\n").length, 1) if @renderer.uglifier
      end
    end
  end
end
