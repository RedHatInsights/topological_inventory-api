module ApplicationDeployment
  def self.status
    return "new_deployment" if ActiveRecord::Migrator.current_version.zero?
    return "upgrade"        if ActiveRecord::Migrator.needs_migration?
    "other"
  end
end

desc "Determine the deployment scenario"
task :deployment_status => :environment do
  status_to_code = {
    "new_deployment" => 3,
    "upgrade"        => 4,
    "other"          => 5
  }

  status = ApplicationDeployment.status

  puts "Deployment status is #{status}"
  exit status_to_code[status]
end
