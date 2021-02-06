require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym 'HTML'
  inflect.acronym 'XML'
  inflect.acronym 'CSS'
end

module Ginseng
  module Web
    def self.dir
      return File.expand_path('../..', __dir__)
    end

    def self.loader
      config = YAML.load_file(File.join(dir, 'config/autoload.yaml'))
      loader = Zeitwerk::Loader.new
      loader.inflector.inflect(config['inflections'])
      loader.push_dir(File.join(dir, 'lib/ginseng/web'), namespace: Ginseng::Web)
      return loader
    end

    Bundler.require
    loader.setup
  end
end
