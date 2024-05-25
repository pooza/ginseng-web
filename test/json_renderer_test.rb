module Ginseng
  module Web
    class JSONRendererTest < Test::Unit::TestCase
      def setup
        @renderer = JSONRenderer.new
        @renderer.message = {a: 1, b: 'string', c: {d: 111, e: 333}}
      end

      def test_new
        assert_kind_of(Renderer, @renderer)
        assert_kind_of(JSONRenderer, @renderer)
      end

      def test_type
        assert_equal('application/json; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404

        assert_equal(404, @renderer.status)
      end

      def test_message
        assert_equal({a: 1, b: 'string', c: {d: 111, e: 333}}, @renderer.message)
      end

      def test_to_s
        assert_equal('{"a":1,"b":"string","c":{"d":111,"e":333}}', @renderer.to_s)
      end
    end
  end
end
