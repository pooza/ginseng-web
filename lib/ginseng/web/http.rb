require 'webrick'

module Ginseng
  module Web
    class HTTP < Ginseng::HTTP
      def self.create_basic_auth(user, password)
        return "Basic #{"#{user}:#{password}".base64.chomp}"
      end

      def self.parse_header(contents)
        return ::WEBrick::HTTPUtils.parse_header(contents)
      end
    end
  end
end
