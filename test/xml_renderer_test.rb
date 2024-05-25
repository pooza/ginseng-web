module Ginseng
  module Web
    class XMLRendererTest < Test::Unit::TestCase
      def setup
        @renderer = XMLRenderer.new
        @renderer.message = 'hoge message'
      end

      def test_new
        assert_kind_of(Renderer, @renderer)
        assert_kind_of(XMLRenderer, @renderer)
      end

      def test_type
        assert_equal('application/xml; charset=UTF-8', @renderer.type)
      end

      def test_status
        assert_equal(200, @renderer.status)
        @renderer.status = 404

        assert_equal(404, @renderer.status)
      end

      def test_message
        assert_equal('hoge message', @renderer.message)
      end

      def test_to_s
        assert_equal(%(<?xml version='1.0' encoding='UTF-8'?><result><message>hoge message</message></result>), @renderer.to_s)
      end
    end
  end
end
