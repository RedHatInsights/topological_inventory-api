module Api
  module V1x0
    class RootController < ApplicationController
      def openapi
        render :json => ::ManageIQ::API::Common::OpenApi::Docs.instance["1.0"].to_json
      end
    end

    class AvailabilitiesController              < Api::V1::AvailabilitiesController; end
    class ClustersController                    < Api::V1::ClustersController; end
    class ContainersController                  < Api::V1::ContainersController; end
    class ContainerGroupsController             < Api::V1::ContainerGroupsController; end
    class ContainerImagesController             < Api::V1::ContainerImagesController; end
    class ContainerNodesController              < Api::V1::ContainerNodesController; end
    class ContainerProjectsController           < Api::V1::ContainerProjectsController; end
    class ContainerResourceQuotasController     < Api::V1::ContainerResourceQuotasController; end
    class ContainerTemplatesController          < Api::V1::ContainerTemplatesController; end
    class DatastoresController                  < Api::V1::DatastoresController; end
    class FlavorsController                     < Api::V1::FlavorsController; end
    class HostsController                       < Api::V1::HostsController; end
    class IpaddressesController                 < Api::V1::IpaddressesController; end
    class NetworkAdaptersController             < Api::V1::NetworkAdaptersController; end
    class NetworksController                    < Api::V1::NetworksController; end
    class OrchestrationStacksController         < Api::V1::OrchestrationStacksController; end
    class SecurityGroupsController              < Api::V1::SecurityGroupsController; end
    class ServiceInstancesController            < Api::V1::ServiceInstancesController; end
    class ServiceOfferingIconsController        < Api::V1::ServiceOfferingIconsController; end
    class ServiceOfferingsController            < Api::V1::ServiceOfferingsController; end
    class ServicePlansController                < Api::V1::ServicePlansController; end
    class SourceRegionsController               < Api::V1::SourceRegionsController; end
    class SourcesController                     < Api::V1::SourcesController; end
    class SubnetsController                     < Api::V1::SubnetsController; end
    class SubscriptionsController               < Api::V1::SubscriptionsController; end
    class TagsController                        < Api::V1::TagsController; end
    class TasksController                       < Api::V1::TasksController; end
    class VmsController                         < Api::V1::VmsController; end
    class VolumeAttachmentsController           < Api::V1::VolumeAttachmentsController; end
    class VolumeTypesController                 < Api::V1::VolumeTypesController; end
    class VolumesController                     < Api::V1::VolumesController; end
  end
end
