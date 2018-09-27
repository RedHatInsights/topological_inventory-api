class Source < ApplicationRecord
  has_many :endpoints, :dependent => :destroy

  # Container Inventory Objects
  has_many :container_groups,    :dependent => :destroy
  has_many :container_templates, :dependent => :destroy
  has_many :container_projects,  :dependent => :destroy

  # Service Catalog Inventory Objects
  has_many :service_offerings,       :dependent => :destroy
  has_many :service_instances,       :dependent => :destroy
  has_many :service_parameters_sets, :dependent => :destroy
end
