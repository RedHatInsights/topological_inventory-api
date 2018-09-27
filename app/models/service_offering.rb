class ServiceOffering < ApplicationRecord
  belongs_to :source

  has_many :service_instances,       :dependent => :nullify
  has_many :service_parameters_sets, :dependent => :nullify
end
