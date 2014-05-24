Tegu::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Grape api
  mount Api => '/'

  # You can have the root of your site routed with "root"
  # root 'landing#index'
  get '/' => redirect("/landing")
  get 'landing(/:code)' => 'landing#index', as: :landing

  root 'listings#index'
  get 'reptiles/:category' => "listings#by_category", constraints: { category: /[a-z-]+/ },
    as: :reptile_category
  resources :reptiles, controller: 'listings'
  resources :listings
  resources :listing_forms, only: [] do
    get :new_image, on: :collection
  end

  # oauth
  get 'auth/:provider/callback', to: 'oauths#callback'
  get 'auth/failure', to: 'oauths#failure'

  # users
  resources :users, only: [:index] do
    get 'become', on: :member
    get 'validate_email', :on => :collection
    get 'validate_handle', :on => :collection
  end
  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new", :as => :login
    get "signup", to: "devise/registrations#new", :as => :signup
    get "logout", to: "devise/sessions#destroy", :as => :logout
  end

  # signup
  get 'signup/new/facebook', to: "signup#new_facebook", as: :new_facebook_signup
  get 'signup/new/password', to: "signup#new_password", as: :new_password_signup
  post 'signup/create/facebook', to: "signup#create_facebook", as: :create_facebook_signup
  post 'signup/create/password', to: "signup#create_password", as: :create_password_signup

  resources :waitlists, only: [:index]

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
