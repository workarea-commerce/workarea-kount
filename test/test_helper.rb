require 'simplecov'

SimpleCov.start 'rails' do
  add_group 'View Models', 'app/view_models'
  add_filter 'lib/workarea/kount/version.rb'
  add_filter 'lib/workarea/mailer_previews/storefront/order_mailer_preview.rb'
  add_filter 'lib/workarea/kount/bogus_gateway.rb'
  add_filter %r{app/services/workarea/kount/event/.*\.rb}
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
require 'rails/test_help'
require 'workarea/test_help'

Minitest.backtrace_filter = Minitest::BacktraceFilter.new
