require 'sidekiq/web'
Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/console', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

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
      get :initialize_validations
    end
  end

  resources :units
  resources :instructions
  resources :docs
  resources :first_level_units

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
    resources :entry_indicators do
      collection do
        post 'edit_individual'
        post 'update_individual'
        post 'search'
      end
    end
    resources :stats
    resources :in_works
    resources :roles, only: [:index]
    resources :rpts do
      collection { post :import }
    end
    resources :unit_rpt_assignations do
      collection {
        get :init
        get :copy
        post :import
        post :update_assignations
      }
    end
    resources :first_level_units do
      collection { post :import }
    end
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
    resources :indicator_metrics do
      member do
        put 'add_empty_source'
        put 'destroy_source'
      end
    end
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
    resources :units do
      collection do
        get 'export_rpt'
      end
    end
    resources :unit_statuses
    resources :in_works
  end

end
