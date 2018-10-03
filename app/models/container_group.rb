class ContainerGroup < ApplicationRecord
  belongs_to :source
  belongs_to :container_project
end
