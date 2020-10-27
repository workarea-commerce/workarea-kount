source 'https://rubygems.org'
git_source(:github) do |repo|
  if !ENV['ACCESS_TOKEN'].nil?
    "https://#{ENV['ACCESS_TOKEN']}@github.com/#{repo}.git"
  else
    "https://github.com/#{repo}.git"
  end
end

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
