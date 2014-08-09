$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'alfredlite/version'

Gem::Specification.new do |s|
  s.name        = 'alfredlite'
  s.version     = Alfred::VERSION
  s.summary     = 'AlfredLite is a lightweight modular framework for creating Alfred workflows.'
  s.authors     = ['Chris Lucas']
  s.email       = ['chris@chrisjlucas.com']
  s.homepage    = 'https://github.com/cjlucas/ruby-alfredlite'
  s.license     = 'MIT'
  s.files       = `git ls-files | egrep '^[^\.]'`.split(/\r?\n/)
  s.test_files  = s.files.select { |f| f.match(/^spec\/.*\.rb$/) }
  s.platform    = Gem::Platform::RUBY
end
