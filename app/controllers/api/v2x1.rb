module Api
  module V2x1
    class RootController < ApplicationController
      def openapi
        render :json => ::Insights::API::Common::OpenApi::Docs.instance["2.1"].to_json
      end
    end

    class AvailabilitiesController              < Api::V2x0::AvailabilitiesController; end
    class ClustersController                    < Api::V2x0::ClustersController; end
    class ContainerGroupsController             < Api::V2x0::ContainerGroupsController; end
    class ContainerImagesController             < Api::V2x0::ContainerImagesController; end
    class ContainerNodesController              < Api::V2x0::ContainerNodesController; end
    class ContainerProjectsController           < Api::V2x0::ContainerProjectsController; end
    class ContainerResourceQuotasController     < Api::V2x0::ContainerResourceQuotasController; end
    class ContainersController                  < Api::V2x0::ContainersController; end
    class ContainerTemplatesController          < Api::V2x0::ContainerTemplatesController; end
    class DatastoresController                  < Api::V2x0::DatastoresController; end
    class FlavorsController                     < Api::V2x0::FlavorsController; end
    class GraphqlController                     < Api::V2x0::GraphqlController; end
    class HostsController                       < Api::V2x0::HostsController; end
    class IpaddressesController                 < Api::V2x0::IpaddressesController; end
    class NetworkAdaptersController             < Api::V2x0::NetworkAdaptersController; end
    class NetworksController                    < Api::V2x0::NetworksController; end
    class OrchestrationStacksController         < Api::V2x0::OrchestrationStacksController; end
    class SecurityGroupsController              < Api::V2x0::SecurityGroupsController; end
    class ServiceInstanceNodesController        < Api::V2x0::ServiceInstanceNodesController; end
    class ServiceInstancesController            < Api::V2x0::ServiceInstancesController; end
    class ServiceInventoriesController          < Api::V2x0::ServiceInventoriesController; end
    class ServiceOfferingIconsController        < Api::V2x0::ServiceOfferingIconsController; end
    class ServiceOfferingNodesController        < Api::V2x0::ServiceOfferingNodesController; end
    class ServiceOfferingsController            < Api::V2x0::ServiceOfferingsController; end
    class ServicePlansController                < Api::V2x0::ServicePlansController; end
    class SourceRegionsController               < Api::V2x0::SourceRegionsController; end
    class SourcesController                     < Api::V2x0::SourcesController; end
    class SubnetsController                     < Api::V2x0::SubnetsController; end
    class SubscriptionsController               < Api::V2x0::SubscriptionsController; end
    class TagsController                        < Api::V2x0::TagsController; end
    class TasksController                       < Api::V2x0::TasksController; end
    class VmsController                         < Api::V2x0::VmsController; end
    class VolumeAttachmentsController           < Api::V2x0::VolumeAttachmentsController; end
    class VolumesController                     < Api::V2x0::VolumesController; end
    class VolumeTypesController                 < Api::V2x0::VolumeTypesController; end
    class TaggingsController                    < Api::V2x0::TaggingsController; end
  end
end
