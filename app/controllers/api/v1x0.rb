module Api
  module V1x0
    class RootController < ApplicationController
      def openapi
        render :json => ::ManageIQ::API::Common::OpenApi::Docs.instance["1.0"].to_json
      end
    end

    class AvailabilitiesController              < Api::V0x1::AvailabilitiesController; end
    class ContainersController                  < Api::V0x1::ContainersController; end
    class ContainerGroupsController             < Api::V0x1::ContainerGroupsController; end
    class ContainerImagesController             < Api::V0x1::ContainerImagesController; end
    class ContainerNodesController              < Api::V0x1::ContainerNodesController; end
    class ContainerProjectsController           < Api::V0x1::ContainerProjectsController; end
    class ContainerResourceQuotasController     < Api::V0x1::ContainerResourceQuotasController; end
    class ContainerTemplatesController          < Api::V0x1::ContainerTemplatesController; end
    class FlavorsController                     < Api::V0x1::FlavorsController; end
    class OrchestrationStacksController         < Api::V0x1::OrchestrationStacksController; end
    class ServiceInstancesController            < Api::V0x1::ServiceInstancesController; end
    class ServiceOfferingIconsController        < Api::V0x1::ServiceOfferingIconsController; end
    class ServiceOfferingsController            < Api::V0x1::ServiceOfferingsController; end
    class ServicePlansController                < Api::V0x1::ServicePlansController; end
    class SourcesController                     < Api::V0x1::SourcesController; end
    class TagsController                        < Api::V0x1::TagsController; end
    class TasksController                       < Api::V0x1::TasksController; end
    class VmsController                         < Api::V0x1::VmsController; end
    class VolumeAttachmentsController           < Api::V0x1::VolumeAttachmentsController; end
    class VolumeTypesController                 < Api::V0x1::VolumeTypesController; end
    class VolumesController                     < Api::V0x1::VolumesController; end
  end
end
