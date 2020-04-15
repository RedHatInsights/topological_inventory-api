source 'https://rubygems.org'

plugin "bundler-inject", "~> 1.1"
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem 'activerecord-virtual_attributes', '~> 1.5'
gem 'insights-api-common',             '~> 3.8'
gem 'jbuilder',                        '~> 2.0'
gem 'json-schema',                     '~> 2.8'
gem 'manageiq-loggers',                "~> 0.4.0", ">= 0.4.2"
gem 'manageiq-messaging',              '~> 0.1.2', :require => false
gem 'manageiq-password',               '~> 0.2', ">= 0.2.1"
gem 'mimemagic',                       '~> 0.3.3'
gem 'more_core_extensions'
gem 'pg',                              '~> 1.0', :require => false
gem 'puma',                            '>= 4.3.3', '~> 4.3'
gem 'rack-cors',                       '>= 1.0.4', '~> 1.0'
gem 'rails',                           '>= 5.2.2.1', '~> 5.2.2'
gem 'sources-api-client',              '~> 1.0'

gem 'topological_inventory-core',      '~> 1.0.0'

group :development, :test do
  gem 'simplecov'
end

group :test do
  gem 'rspec-rails', '~>3.8'
end
