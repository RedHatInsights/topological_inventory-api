source 'https://rubygems.org'

plugin "bundler-inject", "~> 1.1"
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem 'activerecord-virtual_attributes', '~> 1.5'
gem 'cloudwatchlogger',                '~> 0.2.1'
gem 'insights-api-common',             '~> 4.0'
gem 'jbuilder',                        '~> 2.0'
gem 'json-schema',                     '~> 2.8'
gem 'manageiq-loggers',                "~> 0.4.0", ">= 0.4.2"
gem 'manageiq-messaging',              '~> 1.0.0'
gem 'manageiq-password',               '~> 0.2', ">= 0.2.1"
gem 'mimemagic',                       '~> 0.3.3'
gem 'more_core_extensions'
gem 'pg',                              '~> 1.0', :require => false
gem 'puma',                            '~> 4.3.5', '>= 4.3.5'
gem 'rack-cors',                       '>= 1.0.4'
gem 'rails',                           '>= 5.2.2.1', '~> 5.2.2'
gem 'sources-api-client',              '~> 1.0'
gem 'topological_inventory-core',      '~> 1.2.0'

group :development, :test do
  gem "rubocop",             "~> 1.0.0", :require => false
  gem "rubocop-performance", "~> 1.8",   :require => false
  gem "rubocop-rails",       "~> 2.8",   :require => false
  gem "simplecov",           "~> 0.17.1"
end

group :test do
  gem 'rspec-rails', '~>3.8'
end
