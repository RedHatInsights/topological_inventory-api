class ServiceInstance < ApplicationRecord
  belongs_to :source
  belongs_to :service_offering
  belongs_to :service_parameters_set
end
