require 'rack/test'

module Ginseng
  module Web
    class HTTPTest < Test::Unit::TestCase
      def test_create_basic_auth
        assert_equal(HTTP.create_basic_auth('aaa', 'bbb'), 'Basic YWFhOmJiYg==')
      end
    end
  end
end
