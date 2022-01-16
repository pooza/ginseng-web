module Ginseng
  module Web
    module Refines
      class ::String
        def base64
          require 'base64'
          return Base64.encode64(self)
        end
      end
    end
  end
end
