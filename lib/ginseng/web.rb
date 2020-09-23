require 'ginseng'
require 'active_support/dependencies/autoload'

module Ginseng
  module Web
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :Environment
    autoload :Logger
    autoload :Package
    autoload :Renderer
    autoload :Sinatra
    autoload :Template
    autoload :TestCase
    autoload :TestCaseFilter

    autoload_under 'renderer' do
      autoload :AtomFeedRenderer
      autoload :CSSRenderer
      autoload :HTMLRenderer
      autoload :JSONRenderer
      autoload :XMLRenderer
      autoload :SlimRenderer
    end

    autoload_under 'test_case_filter' do
      autoload :CITestCaseFilter
    end
  end
end
