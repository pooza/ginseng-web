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
  spec.required_ruby_version = '>=3.0'

  spec.add_dependency 'erb'
  spec.add_dependency 'puma', '>=5.6.4' # CVE-2022-24790
  spec.add_dependency 'rss'
  spec.add_dependency 'sassc'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'slim'
  spec.add_dependency 'webrick'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'ricecream'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'test-unit'
end
