Tegu::Application.routes.draw do
  get "account" => "account#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Grape api
  mount Api => '/'

  constraints(DomainRoute.new) do
    match "/(*path)" => redirect {|params, req| "//www.fauna.net/#{params[:path]}"},  via: [:get, :post]
  end

  # vanity user scopes
  get ':handle' => "users#show", as: :user, constraints: HandleRoute.new
  get ':handle/listings' => "users#listings", as: :user_listings
  get ':handle/listings/:id' => "listings#show", as: :user_listing
  get ':handle/reviews' => "users#reviews", as: :user_reviews

  # You can have the root of your site routed with "root"
  # root 'landing#index'
  get '/' => redirect("/landing")
  get 'landing/success/:code' => 'landing#success', as: :landing_success
  get 'landing(/:code)' => 'landing#index', as: :landing

  root 'listings#index'
  
  resources :listings, except: [:show]
  resources :listing_forms, only: [] do
    get :subcategories, on: :collection
    get :new_image, on: :collection
  end
  match 'listings/search' => "listings#by_search", as: :listing_search, via: [:get, :post]
  get 'listings/:category(/:subcategory)' => "listings#by_category", constraints: {category: /[a-z-]+/},
    as: :listing_category
  get 'listings/:id' => "listings#show", constraints: {id: /[0-9]+/}

  # oauth
  get 'auth/:provider/callback', to: 'oauths#callback'
  get 'auth/failure', to: 'oauths#failure'

  # users
  resources :users, only: [:index, :show, :update] do
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

  # paypal adaptive pay routes
  get 'paypal/pay/:listing_id/start', to: "paypal#start", as: :paypal_start
  post 'paypal/pay/:payment_id/ipn_notify', to: "paypal#ipn_notify", as: :paypal_ipn_notify
  get 'paypal/pay/:payment_id/:status', to: "paypal#status", as: :paypal_status
  resources :payments, only: [:index]

  # twilio
  match 'twilio/sms/reply' => "twilio#sms_reply", as: :twilio_sms_reply, via: [:get, :post]
  match 'twilio/sms/send'=> "twilio#sms_send", as: :twilio_sms_send, via: [:get, :post]
  match 'twilio/sms/start'=> "twilio#sms_start", as: :twilio_sms_start, via: [:get]
  match 'twilio/sms/verify'=> "twilio#sms_verify", as: :twilio_sms_verify, via: [:get]

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
