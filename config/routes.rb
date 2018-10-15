Rails.application.routes.draw do
  namespace :api do
    namespace :v0x0, :path => "v0.0" do
      resources :container_groups,        :only => [:index, :show]
      resources :container_nodes,         :only => [:index, :show]
      resources :container_projects,      :only => [:index, :show]
      resources :container_templates,     :only => [:index, :show]
      resources :endpoints,               :only => [:create, :destroy, :index, :show, :update]
      resources :service_instances,       :only => [:index, :show]
      resources :service_offerings,       :only => [:index, :show]
      resources :service_parameters_sets, :only => [:index, :show]
      resources :sources,                 :only => [:create, :destroy, :index, :show, :update]
    end
  end
end
