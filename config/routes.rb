Rails.application.routes.draw do


  namespace :admin do
  get 'roles/index'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'sign_in', to: 'sessions#create', as: :sign_in
  resource :session, only: [:create, :destroy]

  resources :in_works
  resources :user_access
  resources :entry_indicators, only: [:edit, :index] do
    collection do
      post 'updates'
      get :download_validation
      get :validated_abstract
    end
  end

  resources :units
  resources :instructions
  resources :docs

  namespace :admin do
    root to: "dashboard#index"
    resources :settings
    resources :organization_types
    resources :unit_types
    resources :organizations
    resources :units
    resources :users do
      member do
        get 'ws_update'
        post 'roles'
        get 'activate'
        get 'remove_role'
        get 'uweb_auth'
      end
      get :search, on: :collection
    end
    resources :stats
    resources :in_works

  end

  namespace :validator do
    root to: "dashboard#index"
    resources :users
    resources :roles, only: [:index, :create, :destroy] do
      member do
        post 'add_resource'
        get  'remove_resource'
      end
      get :search, on: :collection
    end
  end

  namespace :supervisor do
    root to: "dashboard#index"
      resources :sources
      resources :process_summary
      resources :periods
      resources :indicators  do
        member do
          post 'edit'
         end
      end
      resources :tasks  do
        member do
          post 'edit'
         end
      end
        resources :sub_processes  do
        member do
          post 'edit'
         end
      end

      resources :main_processes

      resources :items do
        member do
          post 'edit'
        end
      end
      resources :indicators
      resources :indicator_metrics

      resources :in_works
  end

end
