desc 'test all'
task :test do
  ENV['TEST'] = Ginseng::Web::Package.name
  require 'test/unit'
  Dir.glob(File.join(Ginseng::Web::Environment.dir, 'test/*.rb')).each do |t|
    require t
  end
end
