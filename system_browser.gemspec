Gem::Specification.new do |s|
  s.name         = 'system_browser'
  s.version      = File.read('VERSION')
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = ''
  s.description  = ''
  s.author       = 'Kyrylo Silin'
  s.email        = 'silin@kyrylo.org'
  s.homepage     = 'https://github.com/kyrylo/system_browser'
  s.licenses     = 'Zlib'

  s.require_path = 'lib'
  s.files        = %w[
    lib/system_browser.rb
    lib/system_browser/server.rb
    lib/system_browser/message.rb
    lib/system_browser/message/add_gem_message.rb
    VERSION
    README.md
    CHANGELOG.md
    LICENCE.txt
  ]
  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'system_navigation', '~> 0'
  s.add_runtime_dependency 'core_classes', '~> 0'

  s.add_development_dependency 'bundler', '~> 1.9'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'pry', '~> 0.10'
end
