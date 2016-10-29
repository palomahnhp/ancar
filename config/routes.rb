Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'sign_in', to: 'sessions#create', as: :sign_in
  resource :session, only: [:create, :destroy]

  resources :in_works
  resources :user_access
  resources :entry_indicators
  resources :instructions

  namespace :admin do
    root to: "dashboard#index"
    resources :settings
    resources :organization_types
    resources :unit_types
    resources :organizations
    resources :units
    resources :stats
    resources :in_works
  end

  namespace :manager do
    root to: "dashboard#index"
      resources :sources
      resources :process_summary
      resources :periods do
        member do
          post 'edit'
         end
      end
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
      resources :main_processes do
        member do
          post 'edit'
         end
      end
      resources :in_works
      resources :items do
        member do
          post 'edit'
        end
      end

  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
