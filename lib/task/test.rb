namespace :ginseng do
  namespace :web do
    task :test do
      ENV['TEST'] = Ginseng::Web::Package.name
      require 'test/unit'
      Dir.glob(File.join(Ginseng::Web::Environment.dir, 'test/*')).each do |t|
        require t
      end
    end
  end
end
