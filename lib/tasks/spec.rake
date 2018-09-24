namespace :spec do
  task :initialize do
    ENV["RAILS_ENV"] ||= "test"
    Rails.env = ENV["RAILS_ENV"] if defined?(Rails)
  end

  task :setup_db => ["db:drop", "db:create", "db:migrate"]

  desc "Prepare all specs"
  task :setup => [:initialize, :setup_db]
end
