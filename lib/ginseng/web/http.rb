module Ginseng
  module Web
    class HTTP < Ginseng::HTTP
      def self.create_basic_auth(user, password)
        return "Basic #{"#{user}:#{password}".base64.chomp}"
      end

      def self.parse_header(contents)
        headers = {}
        contents.split(/\r?\n/).each do |line|
          next unless matches = line.match(/^([^:]+): (.*)$/)
          name = matches[1].downcase
          headers[name] ||= []
          headers[name].push(matches[2])
        end
        return headers
      end
    end
  end
end
