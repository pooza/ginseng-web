require 'rack/test'

module Ginseng
  module Web
    class HTTPTest < Test::Unit::TestCase
      def test_create_basic_auth
        assert_equal('Basic YWFhOmJiYg==', HTTP.create_basic_auth('aaa', 'bbb'))
      end

      def test_parse_header
        assert_equal(
          {'content-length' => ['100'], 'content-type' => ['text/plain']},
          HTTP.parse_header("Content-Type: text/plain\nContent-Length: 100"),
        )
      end
    end
  end
end
