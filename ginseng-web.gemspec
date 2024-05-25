require 'yaml'
package = YAML.load_file(File.join(__dir__, 'config/lib.yaml'))['package']

Gem::Specification.new do |spec|
  spec.name = 'ginseng-web'
  spec.version = package['version']
  spec.authors = package['authors']
  spec.email = package['email']
  spec.summary = package['description']
  spec.description = package['description']
  spec.homepage = package['url']
  spec.license = package['license']
  spec.metadata['homepage_uri'] = package['url']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>=3.2'

  spec.add_dependency 'erb'
  spec.add_dependency 'puma', '>=5.6.4' # CVE-2022-24790
  spec.add_dependency 'rack', '>=2.2.6.4' # CVE-2023-27539
  spec.add_dependency 'rss'
  spec.add_dependency 'sassc'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'slim'
  spec.add_dependency 'tilt', '~>2.1.0'
  spec.add_dependency 'webrick'
end
