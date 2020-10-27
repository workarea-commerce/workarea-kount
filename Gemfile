source 'https://rubygems.org'
git_source(:github) { |repo| "git@github.com:#{repo}.git" }

gemspec

gem 'byebug'

group :test do
  gem 'simplecov'
  gem 'workarea-paypal', '~> 2.x'
  gem 'workarea-api'
  gem 'workarea-quotes',
    github: 'workarea-commerce/workarea-quotes',
    branch: 'QUOTES-4-ensure-decoration-to-order-find-current-works-with-other-plugins'

  case ENV['CC_PROCESSOR']
  when 'moneris'
    gem 'workarea-moneris', source: 'https://gems.workarea.com'
  end
end
