dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'ginseng'
require 'ginseng/web'

Dir.glob(File.join(Ginseng::Web::Environment.dir, 'lib/task/*.rb')).sort.each do |f|
  require f
end
