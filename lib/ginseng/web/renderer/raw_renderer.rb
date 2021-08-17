module Ginseng
  module Web
    class RawRenderer < Renderer
      attr_accessor :type, :body

      alias to_s body
    end
  end
end
