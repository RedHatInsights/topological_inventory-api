source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.0.7"
# Use postgres as the database for Active Record
gem "pg", "~>0.18.2", :require => false
# Use Puma as the app server
gem "puma", "~> 3.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"
# Use inventory_refresh for persisting inventory to postgres
gem "inventory_refresh", "~>0.1.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
end
