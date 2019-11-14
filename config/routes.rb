Rails.application.routes.draw do
  # Disable PUT for now since rails sends these :update and they aren't really the same thing.
  def put(*_args); end

  routing_helper = Insights::API::Common::Routing.new(self)
  prefix = "api"
  if ENV["PATH_PREFIX"].present? && ENV["APP_NAME"].present?
    prefix = File.join(ENV["PATH_PREFIX"], ENV["APP_NAME"]).gsub(/^\/+|\/+$/, "")
  end

  scope :as => :api, :module => "api", :path => prefix do
    routing_helper.redirect_major_version("v2.0", prefix)
    routing_helper.redirect_major_version("v1.0", prefix)

    namespace :v2x0, :path => "v2.0" do
      get "/openapi.json", :to => "root#openapi"
      post "graphql" => "graphql#query"

      concern :taggable do
        resources :tags,             :only => [:create, :index], :controller => :taggings do
          collection do
            delete "", :action => :destroy
          end
        end
      end

      resources :clusters,                :only => [:index, :show] do
        resources :hosts, :only => [:index]
      end
      resources :container_groups,        :only => [:index, :show], :concerns => [:taggable] do
        resources :containers, :only => [:index]
      end
      resources :container_images,        :only => [:index, :show], :concerns => [:taggable]
      resources :container_nodes,         :only => [:index, :show], :concerns => [:taggable] do
        resources :container_groups, :only => [:index]
      end
      resources :container_projects,      :only => [:index, :show], :concerns => [:taggable] do
        resources :container_groups,          :only => [:index]
        resources :container_resource_quotas, :only => [:index]
        resources :container_templates,       :only => [:index]
      end
      resources :container_resource_quotas, :only => [:index, :show]
      resources :container_templates,     :only => [:index, :show], :concerns => [:taggable]
      resources :containers,              :only => [:index, :show]
      resources :datastores,              :only => [:index, :show]
      resources :flavors,                 :only => [:index, :show]
      resources :hosts,                   :only => [:index, :show]
      resources :ipaddresses,             :only => [:index, :show], :concerns => [:taggable]
      resources :network_adapters,        :only => [:index, :show], :concerns => [:taggable] do
        resources :ipaddresses, :only => [:index]
      end
      resources :networks,                :only => [:index, :show], :concerns => [:taggable] do
        resources :subnets, :only => [:index]
      end
      resources :orchestration_stacks, :only => [:index, :show] do
        resources :ipaddresses,       :only => [:index]
        resources :network_adapters,  :only => [:index]
        resources :networks,          :only => [:index]
        resources :security_groups,   :only => [:index]
        resources :subnets,           :only => [:index]
        resources :vms,               :only => [:index]
        resources :volumes,           :only => [:index]
      end
      resources :security_groups,         :only => [:index, :show], :concerns => [:taggable] do
        resources :vms,  :only => [:index]
      end
      resources :service_instance_nodes,  :only => [:index, :show]
      resources :service_instances,       :only => [:index, :show] do
        resources :service_instance_nodes, :only => [:index]
      end
      resources :service_inventories,     :only => [:index, :show], :concerns => [:taggable]
      resources :service_offering_icons,  :only => [:index, :show] do
        get "icon_data", :to => "service_offering_icons#icon_data"
      end
      resources :service_offering_nodes,  :only => [:index, :show]
      resources :service_offerings,       :only => [:index, :show], :concerns => [:taggable] do
        post "applied_inventories", :to => "service_offerings#applied_inventories"
        post "order", :to => "service_offerings#order"
        resources :service_instances,      :only => [:index]
        resources :service_offering_nodes, :only => [:index]
        resources :service_plans,          :only => [:index]
      end
      resources :service_plans, :only => [:index, :show] do
        post "order", :to => "service_plans#order"
        resources :service_instances, :only => [:index]
      end
      resources :source_regions, :only => [:index, :show] do
        resources :ipaddresses,           :only => [:index]
        resources :network_adapters,      :only => [:index]
        resources :networks,              :only => [:index]
        resources :orchestration_stacks,  :only => [:index]
        resources :security_groups,       :only => [:index]
        resources :service_instances,     :only => [:index]
        resources :service_offerings,     :only => [:index]
        resources :service_plans,         :only => [:index]
        resources :subnets,               :only => [:index]
        resources :vms,                   :only => [:index]
        resources :volumes,               :only => [:index]
      end
      resources :sources,                 :only => [:index, :show] do
        resources :availabilities,         :only => [:index]
        resources :clusters,               :only => [:index]
        resources :container_groups,       :only => [:index]
        resources :container_images,       :only => [:index]
        resources :container_nodes,        :only => [:index]
        resources :container_projects,     :only => [:index]
        resources :container_templates,    :only => [:index]
        resources :containers,             :only => [:index]
        resources :datastores,             :only => [:index]
        resources :hosts,                  :only => [:index]
        resources :ipaddresses,            :only => [:index]
        resources :network_adapters,       :only => [:index]
        resources :networks,               :only => [:index]
        resources :orchestration_stacks,   :only => [:index]
        resources :security_groups,        :only => [:index]
        resources :service_instance_nodes, :only => [:index]
        resources :service_instances,      :only => [:index]
        resources :service_inventories,    :only => [:index]
        resources :service_offering_nodes, :only => [:index]
        resources :service_offerings,      :only => [:index]
        resources :service_plans,          :only => [:index]
        resources :source_regions,         :only => [:index]
        resources :subnets,                :only => [:index]
        resources :subscriptions,          :only => [:index]
        resources :vms,                    :only => [:index]
        resources :volume_types,           :only => [:index]
        resources :volumes,                :only => [:index]
      end
      resources :subnets,                 :only => [:index, :show], :concerns => [:taggable] do
        resources :ipaddresses,      :only => [:index]
        resources :network_adapters, :only => [:index]
      end
      resources :subscriptions, :only => [:index, :show] do
        resources :ipaddresses,           :only => [:index]
        resources :network_adapters,      :only => [:index]
        resources :networks,              :only => [:index]
        resources :orchestration_stacks,  :only => [:index]
        resources :security_groups,       :only => [:index]
        resources :service_instances,     :only => [:index]
        resources :service_offerings,     :only => [:index]
        resources :service_plans,         :only => [:index]
        resources :subnets,               :only => [:index]
        resources :vms,                   :only => [:index]
        resources :volumes,               :only => [:index]
      end
      resources :tags, :only => [:index, :show] do
        resources :container_groups,    :only => [:index]
        resources :container_images,    :only => [:index]
        resources :container_nodes,     :only => [:index]
        resources :container_projects,  :only => [:index]
        resources :container_templates, :only => [:index]
        resources :ipaddresses,         :only => [:index]
        resources :network_adapters,    :only => [:index]
        resources :networks,            :only => [:index]
        resources :security_groups,     :only => [:index]
        resources :service_inventories, :only => [:index]
        resources :service_offerings,   :only => [:index]
        resources :subnets,             :only => [:index]
        resources :vms,                 :only => [:index]
      end
      resources :tasks, :only => [:index, :show, :update]
      resources :vms, :only => [:index, :show], :concerns => [:taggable] do
        resources :network_adapters,   :only => [:index]
        resources :security_groups,    :only => [:index]
        resources :volume_attachments, :only => [:index]
        resources :volumes,            :only => [:index]
      end
      resources :volume_attachments, :only => [:index, :show]
      resources :volume_types,       :only => [:index, :show] do
        resources :volumes, :only => [:index]
      end
      resources :volumes,            :only => [:index, :show] do
        resources :vms, :only => [:index]
      end
    end

    namespace :v1x0, :path => "v1.0" do
      get "/openapi.json", :to => "root#openapi"
      post "graphql" => "graphql#query"

      resources :clusters,                :only => [:index, :show] do
        resources :hosts, :only => [:index]
      end
      resources :containers,              :only => [:index, :show]
      resources :container_groups,        :only => [:index, :show] do
        resources :containers, :only => [:index]
        resources :tags,       :only => [:index]
      end
      resources :container_images,        :only => [:index, :show] do
        resources :tags, :only => [:index]
      end
      resources :container_nodes,         :only => [:index, :show] do
        resources :container_groups, :only => [:index]
        resources :tags,             :only => [:index]
      end
      resources :container_projects,      :only => [:index, :show] do
        resources :container_groups,          :only => [:index]
        resources :container_resource_quotas, :only => [:index]
        resources :container_templates,       :only => [:index]
        resources :tags,                      :only => [:index]
      end
      resources :container_resource_quotas, :only => [:index, :show]
      resources :container_templates,     :only => [:index, :show] do
        resources :tags, :only => [:index]
      end
      resources :datastores,              :only => [:index, :show]
      resources :flavors,                 :only => [:index, :show]
      resources :service_instances,       :only => [:index, :show] do
        resources :service_instance_nodes, :only => [:index]
      end
      resources :service_instance_nodes,  :only => [:index, :show]
      resources :service_inventories,     :only => [:index, :show] do
        resources :tags, :only => [:index]
      end
      resources :service_offering_icons,  :only => [:index, :show] do
        get "icon_data", :to => "service_offering_icons#icon_data"
      end
      resources :service_offering_nodes,  :only => [:index, :show]
      resources :hosts,                   :only => [:index, :show]
      resources :security_groups,         :only => [:index, :show] do
        resources :tags, :only => [:index]
        resources :vms,  :only => [:index]
      end
      resources :ipaddresses,             :only => [:index, :show] do
        resources :tags, :only => [:index]
      end
      resources :network_adapters,        :only => [:index, :show] do
        resources :ipaddresses, :only => [:index]
        resources :tags,        :only => [:index]
      end
      resources :subnets,                 :only => [:index, :show] do
        resources :ipaddresses,      :only => [:index]
        resources :network_adapters, :only => [:index]
        resources :tags,             :only => [:index]
      end
      resources :networks,                :only => [:index, :show] do
        resources :subnets, :only => [:index]
        resources :tags,    :only => [:index]
      end
      resources :service_offerings,       :only => [:index, :show] do
        post "applied_inventories", :to => "service_offerings#applied_inventories"
        post "order", :to => "service_offerings#order"
        resources :service_instances,      :only => [:index]
        resources :service_offering_nodes, :only => [:index]
        resources :service_plans,          :only => [:index]
        resources :tags,                   :only => [:index]
      end
      resources :subscriptions, :only => [:index, :show] do
        resources :ipaddresses,           :only => [:index]
        resources :network_adapters,      :only => [:index]
        resources :networks,              :only => [:index]
        resources :orchestration_stacks,  :only => [:index]
        resources :security_groups,       :only => [:index]
        resources :service_instances,     :only => [:index]
        resources :service_offerings,     :only => [:index]
        resources :service_plans,         :only => [:index]
        resources :subnets,               :only => [:index]
        resources :vms,                   :only => [:index]
        resources :volumes,               :only => [:index]
      end
      resources :source_regions, :only => [:index, :show] do
        resources :ipaddresses,           :only => [:index]
        resources :network_adapters,      :only => [:index]
        resources :networks,              :only => [:index]
        resources :orchestration_stacks,  :only => [:index]
        resources :security_groups,       :only => [:index]
        resources :service_instances,     :only => [:index]
        resources :service_offerings,     :only => [:index]
        resources :service_plans,         :only => [:index]
        resources :subnets,               :only => [:index]
        resources :vms,                   :only => [:index]
        resources :volumes,               :only => [:index]
      end
      resources :orchestration_stacks, :only => [:index, :show] do
        resources :ipaddresses,       :only => [:index]
        resources :network_adapters,  :only => [:index]
        resources :networks,          :only => [:index]
        resources :security_groups,   :only => [:index]
        resources :subnets,           :only => [:index]
        resources :vms,               :only => [:index]
        resources :volumes,           :only => [:index]
      end
      resources :service_plans, :only => [:index, :show] do
        post "order", :to => "service_plans#order"
        resources :service_instances, :only => [:index]
      end
      resources :sources,                 :only => [:index, :show] do
        resources :availabilities,         :only => [:index]
        resources :clusters,               :only => [:index]
        resources :containers,             :only => [:index]
        resources :container_groups,       :only => [:index]
        resources :container_images,       :only => [:index]
        resources :container_nodes,        :only => [:index]
        resources :container_projects,     :only => [:index]
        resources :container_templates,    :only => [:index]
        resources :datastores,             :only => [:index]
        resources :hosts,                  :only => [:index]
        resources :ipaddresses,            :only => [:index]
        resources :network_adapters,       :only => [:index]
        resources :networks,               :only => [:index]
        resources :orchestration_stacks,   :only => [:index]
        resources :security_groups,        :only => [:index]
        resources :service_instances,      :only => [:index]
        resources :service_instance_nodes, :only => [:index]
        resources :service_inventories,    :only => [:index]
        resources :service_offerings,      :only => [:index]
        resources :service_offering_nodes, :only => [:index]
        resources :service_plans,          :only => [:index]
        resources :source_regions,         :only => [:index]
        resources :subnets,                :only => [:index]
        resources :subscriptions,          :only => [:index]
        resources :vms,                    :only => [:index]
        resources :volume_types,           :only => [:index]
        resources :volumes,                :only => [:index]
      end
      resources :tags, :only => [:index, :show] do
        resources :container_groups,    :only => [:index]
        resources :container_images,    :only => [:index]
        resources :container_nodes,     :only => [:index]
        resources :container_projects,  :only => [:index]
        resources :container_templates, :only => [:index]
        resources :ipaddresses,         :only => [:index]
        resources :network_adapters,    :only => [:index]
        resources :networks,            :only => [:index]
        resources :security_groups,     :only => [:index]
        resources :service_inventories, :only => [:index]
        resources :service_offerings,   :only => [:index]
        resources :subnets,             :only => [:index]
        resources :vms,                 :only => [:index]
      end
      resources :tasks, :only => [:index, :show, :update]
      resources :vms, :only => [:index, :show] do
        resources :network_adapters,   :only => [:index]
        resources :security_groups,    :only => [:index]
        resources :tags,               :only => [:index]
        resources :volume_attachments, :only => [:index]
        resources :volumes,            :only => [:index]
      end
      resources :volume_attachments, :only => [:index, :show]
      resources :volume_types,       :only => [:index, :show] do
        resources :volumes, :only => [:index]
      end
      resources :volumes,            :only => [:index, :show] do
        resources :vms, :only => [:index]
      end
    end

    namespace :cfme do
      resources :manifest, :only => [:show], :constraints => {:id => /[\d\.]+/}
    end
  end

  scope :as => :internal, :module => "internal", :path => "internal" do
    routing_helper.redirect_major_version("v1.0", "internal", :via => [:get])

    namespace :v1x0, :path => "v1.0" do
      resources :sources, :only => [:update]
      resources :tenants, :only => [:index, :show]
    end
  end

  match "*path", :to => "api/root#invalid_url_error", :via => ActionDispatch::Routing::HTTP_METHODS
end
