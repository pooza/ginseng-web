module Ginseng
  module Web
    class HTTP < Ginseng::HTTP
      def self.create_basic_auth(user, password)
        return "Basic #{"#{user}:#{password}".base64.chomp}"
      end
    end
  end
end
