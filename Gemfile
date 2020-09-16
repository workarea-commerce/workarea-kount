source 'https://rubygems.org'
git_source(:github) { |repo| "git@github.com:#{repo}.git" }

gemspec

gem 'workarea-ci'
gem 'byebug'

group :test do
  gem 'simplecov'
  gem 'workarea-paypal', '~> 2.x'

  case ENV['CC_PROCESSOR']
  when 'moneris'
    gem 'workarea-moneris'
  end
end
