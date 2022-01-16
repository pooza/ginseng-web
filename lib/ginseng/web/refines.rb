module Ginseng
  module Web
    module Refines
      class ::String
        def base64
          require 'base64'
          return Base64.encode64(self)
        end
      end

      class ::Ginseng::HTTP
        def self.create_basic_auth(user, password)
          return "Basic #{"#{user}:#{password}".base64.chomp}"
        end
      end
    end
  end
end
