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

    autoload_under 'daemon' do
      autoload :ThinDaemon
    end

    autoload_under 'renderer' do
      autoload :CSSRenderer
      autoload :HTMLRenderer
      autoload :JSONRenderer
      autoload :XMLRenderer
    end
  end
end
