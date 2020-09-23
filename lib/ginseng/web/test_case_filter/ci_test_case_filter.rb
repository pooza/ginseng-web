module Ginseng
  module Web
    class CITestCaseFilter < Ginseng::TestCaseFilter
      include Package

      def active?
        return environment_class.ci?
      end
    end
  end
end
