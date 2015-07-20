Gem::Specification.new do |s|
  s.name         = 'system_browser'
  s.version      = File.read('VERSION')
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = 'Powers System Browser Client'
  s.description  = 'Powers System Browser Client, which is a desktop application that displays information about Ruby classes and modules, showing both methods and their source code.'
  s.author       = 'Kyrylo Silin'
  s.email        = 'silin@kyrylo.org'
  s.homepage     = 'https://github.com/kyrylo/system_browser'
  s.licenses     = 'Zlib'

  s.require_path = 'lib'
  s.files        = %w[
    lib/system_browser.rb
    lib/system_browser/behaviour.rb
    lib/system_browser/request.rb
    lib/system_browser/request_processor.rb
    lib/system_browser/server.rb
    lib/system_browser/client.rb
    lib/system_browser/response.rb
    lib/system_browser/session.rb
    lib/system_browser/slogger.rb
    lib/system_browser/gem2markdown.rb
    lib/system_browser/helpers/gem_service_helper.rb
    lib/system_browser/helpers/behaviour_service_helper.rb
    lib/system_browser/services/behaviour_service.rb
    lib/system_browser/services/method_service.rb
    lib/system_browser/services/gem_service.rb
    lib/system_browser/services/source_service.rb
    lib/system_browser/services/abstract_service.rb
    VERSION
    README.md
    CHANGELOG.md
    LICENCE.txt
  ]
  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'system_navigation', '~> 0'
  s.add_runtime_dependency 'core_classes', '~> 0'
  s.add_runtime_dependency 'coderay', '~> 1.1'

  s.add_development_dependency 'bundler', '~> 1.9'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'pry', '~> 0.10'
end
