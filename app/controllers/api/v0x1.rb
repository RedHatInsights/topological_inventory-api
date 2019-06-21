module Api
  module V0x1
    class RootController < ApplicationController
      def openapi
        render :json => ::ManageIQ::API::Common::OpenApi::Docs.instance["0.1"].to_json
      end
    end

    class AvailabilitiesController < Api::V0::AvailabilitiesController; end
    class ContainersController < Api::V0::ContainersController; end
    class ContainerGroupsController < Api::V0::ContainerGroupsController; end
    class ContainerImagesController < Api::V0::ContainerImagesController; end
    class ContainerNodesController < Api::V0::ContainerNodesController; end
    class ContainerProjectsController < Api::V0::ContainerProjectsController; end
    class ContainerResourceQuotasController < Api::V0::ContainerResourceQuotasController; end
    class ContainerTemplatesController < Api::V0::ContainerTemplatesController; end
    class FlavorsController < Api::V0::FlavorsController; end
    class OrchestrationStacksController < Api::V0::OrchestrationStacksController; end
    class ServiceInstancesController < Api::V0::ServiceInstancesController; end
    class ServiceOfferingIconsController < Api::V0::ServiceOfferingIconsController; end
    class ServiceOfferingsController < Api::V0::ServiceOfferingsController; end
    class ServicePlansController < Api::V0::ServicePlansController; end
    class SourcesController < Api::V0::SourcesController; end
    class TagsController < Api::V0::TagsController; end
    class TasksController < Api::V0::TasksController; end
    class VmsController < Api::V0::VmsController; end
    class VolumeAttachmentsController < Api::V0::VolumeAttachmentsController; end
    class VolumeTypesController < Api::V0::VolumeTypesController; end
    class VolumesController < Api::V0::VolumesController; end
  end
end
