Rails.application.routes.draw do
  # Disable PUT for now since rails sends these :update and they aren't really the same thing.
  def put(*_args); end

  routing_helper = ManageIQ::API::Common::Routing.new(self)
  prefix = "api"
  if ENV["PATH_PREFIX"].present? && ENV["APP_NAME"].present?
    prefix = File.join(ENV["PATH_PREFIX"], ENV["APP_NAME"]).gsub(/^\/+|\/+$/, "")
  end

  scope :as => :api, :module => "api", :path => prefix do
    routing_helper.redirect_major_version("v1.0", prefix)
    routing_helper.redirect_major_version("v0.1", prefix)

    namespace :v1x0, :path => "v1.0" do
      get "/openapi.json", :to => "root#openapi"
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
      resources :flavors,                 :only => [:index, :show]
      resources :service_instances,       :only => [:index, :show]
      resources :service_offering_icons,  :only => [:index, :show] do
        get "icon_data", :to => "service_offering_icons#icon_data"
      end
      resources :service_offerings,       :only => [:index, :show] do
        resources :service_instances, :only => [:index]
        resources :service_plans,     :only => [:index]
        resources :tags,              :only => [:index]
      end
      resources :orchestration_stacks, :only => [:index, :show]
      resources :service_plans, :only => [:index, :show] do
        post "order", :to => "service_plans#order"
        resources :service_instances, :only => [:index]
      end
      resources :sources,                 :only => [:create, :destroy, :index, :show, :update] do
        resources :availabilities,          :only => [:index]
        resources :containers,              :only => [:index]
        resources :container_groups,        :only => [:index]
        resources :container_images,        :only => [:index]
        resources :container_nodes,         :only => [:index]
        resources :container_projects,      :only => [:index]
        resources :container_templates,     :only => [:index]
        resources :orchestration_stacks,    :only => [:index]
        resources :service_instances,       :only => [:index]
        resources :service_offerings,       :only => [:index]
        resources :service_plans, :only => [:index]
        resources :vms,                     :only => [:index]
        resources :volume_types,            :only => [:index]
        resources :volumes,                 :only => [:index]
      end
      resources :tags, :only => [:index, :show] do
        resources :container_groups, :only => [:index]
        resources :container_images, :only => [:index]
        resources :container_nodes, :only => [:index]
        resources :container_projects, :only => [:index]
        resources :container_templates, :only => [:index]
        resources :service_offerings, :only => [:index]
        resources :vms, :only => [:index]
      end
      resources :tasks, :only => [:index, :show, :update]
      resources :vms, :only => [:index, :show] do
        resources :volume_attachments, :only => [:index]
        resources :volumes,            :only => [:index]
        resources :tags, :only => [:index]
      end
      resources :volume_attachments, :only => [:index, :show]
      resources :volume_types,       :only => [:index, :show]
      resources :volumes,            :only => [:index, :show]
    end

    namespace :v0x1, :path => "v0.1" do
      get "/openapi.json", :to => "root#openapi"
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
      resources :flavors,                 :only => [:index, :show]
      resources :service_instances,       :only => [:index, :show]
      resources :service_offering_icons,  :only => [:index, :show] do
        get "icon_data", :to => "service_offering_icons#icon_data"
      end
      resources :service_offerings,       :only => [:index, :show] do
        resources :service_instances, :only => [:index]
        resources :service_plans,     :only => [:index]
        resources :tags,              :only => [:index]
      end
      resources :orchestration_stacks, :only => [:index, :show]
      resources :service_plans, :only => [:index, :show] do
        post "order", :to => "service_plans#order"
        resources :service_instances, :only => [:index]
      end
      resources :sources,                 :only => [:index, :show] do
        resources :availabilities,          :only => [:index]
        resources :containers,              :only => [:index]
        resources :container_groups,        :only => [:index]
        resources :container_images,        :only => [:index]
        resources :container_nodes,         :only => [:index]
        resources :container_projects,      :only => [:index]
        resources :container_templates,     :only => [:index]
        resources :orchestration_stacks,    :only => [:index]
        resources :service_instances,       :only => [:index]
        resources :service_offerings,       :only => [:index]
        resources :service_plans, :only => [:index]
        resources :vms,                     :only => [:index]
        resources :volume_types,            :only => [:index]
        resources :volumes,                 :only => [:index]
      end
      resources :tags, :only => [:index, :show] do
        resources :container_groups, :only => [:index]
        resources :container_images, :only => [:index]
        resources :container_nodes, :only => [:index]
        resources :container_projects, :only => [:index]
        resources :container_templates, :only => [:index]
        resources :service_offerings, :only => [:index]
        resources :vms, :only => [:index]
      end
      resources :tasks, :only => [:index, :show, :update]
      resources :vms, :only => [:index, :show] do
        resources :volume_attachments, :only => [:index]
        resources :volumes,            :only => [:index]
        resources :tags, :only => [:index]
      end
      resources :volume_attachments, :only => [:index, :show]
      resources :volume_types,       :only => [:index, :show]
      resources :volumes,            :only => [:index, :show]
    end
  end

  scope :as => :internal, :module => "internal", :path => "internal" do
    routing_helper.redirect_major_version("v0.0", "internal", :via => [:get])

    namespace :v0x0, :path => "v0.0" do
      resources :tenants, :only => [:index, :show]
    end
  end

  match "*path", :to => "api/root#invalid_url_error", :via => ActionDispatch::Routing::HTTP_METHODS
end
