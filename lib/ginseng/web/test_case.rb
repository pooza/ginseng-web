module Ginseng
  module Web
    class TestCase < Ginseng::TestCase
      include Package

      def self.load(cases = nil)
        ENV['TEST'] = Package.name
        names(cases).each do |name|
          puts "+ case: #{name}" if Environment.test?
          require File.join(dir, "#{name}.rb")
        rescue => e
          puts "- case: #{name} (#{e.message})" if Environment.test?
        end
      end

      def self.names(cases = nil)
        if cases
          names = cases.split(',').map(&:underscore)
            .map {|v| [v, "#{v}_test", v.sub(/_test$/, '')]}.flatten
            .select {|v| File.exist?(File.join(dir, "#{v}.rb"))}.compact
        else
          finder = FileFinder.new
          finder.dir = dir
          finder.patterns.push('*.rb')
          names = finder.exec.map {|v| File.basename(v, '.rb')}
        end
        return names.to_set
      end

      def self.dir
        return File.join(Environment.dir, 'test')
      end
    end
  end
end
