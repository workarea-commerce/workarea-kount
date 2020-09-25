$:.push File.expand_path('../lib', __FILE__)

require 'workarea/kount/version'

Gem::Specification.new do |s|
  s.name        = 'workarea-kount'
  s.version     = Workarea::Kount::VERSION
  s.authors     = ['Jake Beresford']
  s.email       = ['jberesford@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-kount'
  s.summary     = 'Kount for the Workarea ecommerce platform.'
  s.description = 'Kount’s award-winning anti-fraud technology. Boost Sales, Beat Fraud with Kount.'
  s.files       = `git ls-files`.split("\n")

  s.add_dependency 'workarea',    '~> 3.x', ">= 3.5"
  s.add_dependency 'rest-client', '~> 2.0'
end
