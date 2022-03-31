module Ginseng
  module Web
    class HTMLRendererTest < Test::Unit::TestCase
      def setup
        @renderer = HTMLRenderer.new
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

      def test_to_s
        @renderer[:mode] = 'string'
        @renderer[:content] = '<div></div>'
        assert_equal("<!doctype html>\n<html lang=\"ja\">\n<body>\n&lt;div&gt;&lt;/div&gt;\n<pre>\n  aaa\n    indent\n  aaa\n</pre>\n<div>\nhoge\n</div>\n</body>\n</html>\n", @renderer.to_s)

        @renderer[:mode] = 'array'
        @renderer[:content] = ['aaa', '<div></div>']
        assert_equal("<!doctype html>\n<html lang=\"ja\">\n<body>\naaa<br>\n&lt;div&gt;&lt;/div&gt;<br>\n<pre>\n  aaa\n    indent\n  aaa\n</pre>\n<div>\nhoge\n</div>\n</body>\n</html>\n", @renderer.to_s)

        @renderer[:mode] = 'hash'
        @renderer[:content] = {a: '<div></div>'}
        assert_equal("<!doctype html>\n<html lang=\"ja\">\n<body>\na &lt;div&gt;&lt;/div&gt;<br>\n<pre>\n  aaa\n    indent\n  aaa\n</pre>\n<div>\nhoge\n</div>\n</body>\n</html>\n", @renderer.to_s)
      end
    end
  end
end
