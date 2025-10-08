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
  spec.required_ruby_version = '>=3.3'

  spec.add_dependency 'erb'
  spec.add_dependency 'puma', '>=6.4.3' # CVE-2024-45614
  spec.add_dependency 'rack', '>=3.2.2' # CVE-2025-61770 CVE-2025-61771 CVE-2025-61772
  spec.add_dependency 'rack-session', '>=2.1.1' # CVE-2025-46336
  spec.add_dependency 'rss'
  spec.add_dependency 'sassc'
  spec.add_dependency 'sinatra', '>=4.1.0' # CVE-2024-21510
  spec.add_dependency 'slim'
  spec.add_dependency 'tilt', '~>2.1.0'
end
