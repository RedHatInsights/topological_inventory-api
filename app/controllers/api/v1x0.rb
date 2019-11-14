module Api
  module V1x0
    class RootController < ApplicationController
      def openapi
        render :json => ::Insights::API::Common::OpenApi::Docs.instance["1.0"].to_json
      end
    end

    class AvailabilitiesController              < Api::V1::AvailabilitiesController; end
    class ClustersController                    < Api::V1::ClustersController; end
    class ContainerGroupsController             < Api::V1::ContainerGroupsController; end
    class ContainerImagesController             < Api::V1::ContainerImagesController; end
    class ContainerNodesController              < Api::V1::ContainerNodesController; end
    class ContainerProjectsController           < Api::V1::ContainerProjectsController; end
    class ContainerResourceQuotasController     < Api::V1::ContainerResourceQuotasController; end
    class ContainersController                  < Api::V1::ContainersController; end
    class ContainerTemplatesController          < Api::V1::ContainerTemplatesController; end
    class DatastoresController                  < Api::V1::DatastoresController; end
    class FlavorsController                     < Api::V1::FlavorsController; end
    class GraphqlController                     < Api::V1::GraphqlController; end
    class HostsController                       < Api::V1::HostsController; end
    class IpaddressesController                 < Api::V1::IpaddressesController; end
    class NetworkAdaptersController             < Api::V1::NetworkAdaptersController; end
    class NetworksController                    < Api::V1::NetworksController; end
    class OrchestrationStacksController         < Api::V1::OrchestrationStacksController; end
    class SecurityGroupsController              < Api::V1::SecurityGroupsController; end
    class ServiceInstanceNodesController        < Api::V1::ServiceInstanceNodesController; end
    class ServiceInstancesController            < Api::V1::ServiceInstancesController; end
    class ServiceInventoriesController          < Api::V1::ServiceInventoriesController; end
    class ServiceOfferingIconsController        < Api::V1::ServiceOfferingIconsController; end
    class ServiceOfferingNodesController        < Api::V1::ServiceOfferingNodesController; end
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
    class VolumesController                     < Api::V1::VolumesController; end
    class VolumeTypesController                 < Api::V1::VolumeTypesController; end
  end
end
