dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'ginseng'
require 'ginseng/web'

namespace :bundle do
  desc 'update gems'
  task :update do
    sh 'bundle update'
  end

  desc 'check gems'
  task :check do
    unless Ginseng::Web::Environment.gem_fresh?
      warn 'gems is not fresh.'
      exit 1
    end
  end
end

desc 'test all'
task :test do
  Ginseng::Web::TestCase.load
end
