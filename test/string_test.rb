require 'rack/test'

module Ginseng
  module Web
    class StringTest < Test::Unit::TestCase
      def test_base64
        assert_equal('44Gh44GP44KP', 'ちくわ'.base64.chomp)
      end
    end
  end
end
