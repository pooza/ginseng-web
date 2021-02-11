module Ginseng
  module Web
    class Environment < Ginseng::Environment
      def self.name
        return File.basename(dir)
      end

      def self.dir
        return Ginseng::Web.dir
      end
    end
  end
end
