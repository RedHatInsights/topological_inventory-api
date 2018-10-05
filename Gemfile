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
gem "topological_inventory", :git => "https://github.com/agrare/topological_inventory", :branch => "master"
gem "inventory_refresh", :git => "https://github.com/ManageIQ/inventory_refresh", :branch => "master"
gem "manageiq-messaging", :git => "https://github.com/ManageIQ/manageiq-messaging", :branch => "master"
gem "manageiq-gems-pending", :git => "https://github.com/ManageIQ/manageiq-gems-pending"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use rspec for testing
  gem "rspec-rails"
end

group :development do
  gem 'listen', '~> 3.0.5'
end

def override_gem(name, *args)
  if dependencies.any?
    raise "Trying to override unknown gem #{name}" unless (dependency = dependencies.find { |d| d.name == name })
    dependencies.delete(dependency)

    calling_file = caller_locations.detect { |loc| !loc.path.include?("lib/bundler") }.path
    calling_dir  = File.dirname(calling_file)

    args.last[:path] = File.expand_path(args.last[:path], calling_dir) if args.last.kind_of?(Hash) && args.last[:path]
    gem(name, *args)
  end
end

# Load other additional Gemfiles
#   Developers can create a file ending in .rb under bundler.d/ to specify additional development dependencies
Dir.glob(File.join(__dir__, 'bundler.d/*.rb')).each { |f| eval_gemfile(File.expand_path(f, __dir__)) }
