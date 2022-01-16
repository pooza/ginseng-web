require 'rack/test'

module Ginseng
  module Web
    class StringTest < Test::Unit::TestCase
      def test_base64
        assert_equal('ちくわ'.base64.chomp, '44Gh44GP44KP')
      end
    end
  end
end
