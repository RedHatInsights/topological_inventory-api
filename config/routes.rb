Rails.application.routes.draw do
  namespace :api do
    namespace :v0x0, :path => "v0.0" do
      resources :container_groups,        :only => [:index, :show]
      resources :container_nodes,         :only => [:index, :show] do
        resources :container_groups, :only => [:index]
      end
      resources :container_projects,      :only => [:index, :show] do
        resources :container_groups,    :only => [:index]
        resources :container_templates, :only => [:index]
      end
      resources :container_templates,     :only => [:index, :show]
      resources :endpoints,               :only => [:create, :destroy, :index, :show, :update]
      resources :service_instances,       :only => [:index, :show]
      resources :service_offerings,       :only => [:index, :show] do
        resources :service_instances,       :only => [:index]
        resources :service_plans, :only => [:index]
      end
      resources :service_plans, :only => [:index, :show] do
        resources :service_instances, :only => [:index]
      end
      resources :sources,                 :only => [:create, :destroy, :index, :show, :update] do
        resources :container_groups,        :only => [:index]
        resources :container_nodes,         :only => [:index]
        resources :container_projects,      :only => [:index]
        resources :container_templates,     :only => [:index]
        resources :endpoints,               :only => [:index]
        resources :service_instances,       :only => [:index]
        resources :service_offerings,       :only => [:index]
        resources :service_plans, :only => [:index]
      end
    end
  end
end
