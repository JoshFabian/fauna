Tegu::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Grape api
  mount Api => '/'

  constraints(DomainRoute.new) do
    match "/(*path)" => redirect {|params, req| "//www.fauna.net/#{params[:path]}"},  via: [:get, :post]
  end

  # vanity user scopes
  get ':handle' => "users#show", as: :user, constraints: HandleRoute.new
  get ':handle/edit' => "users#edit", as: :user_edit
  get ':handle/listings/manage' => "listings#manage", as: :user_manage_listings
  get ':handle/listings/:id/edit' => "listings#edit", as: :user_edit_listing
  get ':handle/listings/:id' => "listings#show", as: :user_listing
  get ':handle/listings' => "users#listings", as: :user_listings
  get ':handle/messages/:id' => "messages#show", as: :user_message
  get ':handle/messages' => "users#messages", as: :user_messages
  get ':handle/reviews' => "users#reviews", as: :user_reviews
  get ':handle/verify' => "users#verify", as: :user_verify

  # You can have the root of your site routed with "root"
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
  resources :users, only: [:edit, :index, :show, :update] do
    get 'become', on: :member
    get 'validate_email', :on => :collection
    get 'validate_handle', :on => :collection
  end
  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new", :as => :login
    get "signup", to: "signup#new", :as => :signup
    get "logout", to: "devise/sessions#destroy", :as => :logout
  end

  # signup
  get 'signup/new/facebook', to: "signup#new_facebook", as: :new_facebook_signup
  get 'signup/new/password', to: "signup#new_password", as: :new_password_signup
  post 'signup/create/facebook', to: "signup#create_facebook", as: :create_facebook_signup
  post 'signup/create/password', to: "signup#create_password", as: :create_password_signup

  # paypal adaptive pay routes
  get 'paypal/pay/:listing_id/start', to: "paypal#start", as: :paypal_start
  post 'paypal/pay/:payment_id/ipn_notify', to: "paypal#ipn_notify", as: :paypal_ipn_notify
  get 'paypal/pay/:payment_id/:status', to: "paypal#status", as: :paypal_status
  get 'paypal/verify_email', to: "paypal#verify_email", as: :paypal_verify_email
  resources :payments, only: [:index]

  # twilio
  get '/sms' => redirect("/sms/send")
  match 'sms/reply' => "twilio#sms_reply", as: :twilio_sms_reply, via: [:get, :post]
  match 'sms/send'=> "twilio#sms_send", as: :twilio_sms_send, via: [:get, :post]
  match 'sms/verify_phone'=> "twilio#sms_verify_phone", as: :twilio_sms_verify_phone, via: [:get]
  match 'sms/list'=> "twilio#sms_list", as: :twilio_sms_list, via: [:get]

  resources :messages, only: [:index]
  resources :plans, only: [:index, :show] do
    get :manage, on: :collection
  end
  resources :reviews, only: [:new, :index]
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
