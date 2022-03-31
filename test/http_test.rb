require 'rack/test'

module Ginseng
  module Web
    class HTTPTest < Test::Unit::TestCase
      def test_create_basic_auth
        assert_equal('Basic YWFhOmJiYg==', HTTP.create_basic_auth('aaa', 'bbb'))
      end
    end
  end
end
