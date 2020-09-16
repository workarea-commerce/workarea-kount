source 'https://rubygems.org'
git_source(:github) { |repo| "git@github.com:#{repo}.git" }

gemspec

gem 'byebug'

group :test do
  gem 'simplecov'
  gem 'workarea-paypal', '~> 2.x'
  gem 'workarea-api'

  case ENV['CC_PROCESSOR']
  when 'moneris'
    gem 'workarea-moneris', source: 'https://gems.workarea.com'
  end
end
