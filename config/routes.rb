Tegu::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Grape api
  mount Api => '/'

  constraints(DomainRoute.new) do
    match "/(*path)" => redirect {|params, req| "//www.fauna.net/#{params[:path]}"},  via: [:get, :post]
  end

  root to: "home#index"
  get '/' => redirect("/listings/recent")

  # password edit route (conflicts with user/edit)
  get 'users/password/edit' => "passwords#edit"

  # charts
  scope '/charts' do
    get '', to: "charts#index"
    get '/listings/categories', to: "charts#listings_categories"
    get '/listings/created', to: "charts#listings_created"
    get '/users/signups', to: "charts#users_signups"
  end

  # vanity user scopes
  get ':slug' => "users#activity", as: :user, constraints: HandleRoute.new
  get ':slug/edit' => "users#edit", as: :user_edit
  get ':slug/exception' => "home#exception"
  get ':slug/listings/manage' => "users#manage_listings", as: :user_manage_listings
  get ':slug/listings/:id/reviews/new' => "reviews#new", as: :new_listing_review
  get ':slug/listings/:id/edit' => "listings#edit", as: :user_edit_listing
  get ':slug/listings/:id/check-share' => "listings#check_share", as: :user_check_share_listing
  get ':slug/listings/:id' => "listings#show", as: :user_listing
  get ':slug/listings' => "users#listings", as: :user_listings
  get ':slug/messages' => "users#messages", as: :user_messages
  get ':slug/purchases' => "users#purchases", as: :user_purchases
  get ':slug/settings' => "users#settings", as: :user_settings
  get ':slug/store/category/:category' => "users#store", as: :user_store_category
  post ':slug/store/search' => "users#store", as: :user_store_search
  get ':slug/store' => "users#store", as: :user_store
  get ':slug/reviews' => "users#reviews", as: :user_reviews
  get ':slug/verify' => "verify#start", as: :user_verify
  get ':slug/verify/paypal', to: "verify#paypal", as: :user_verify_paypal # paypal verify email
  get ':slug/verify/paypal/complete', to: "verify#paypal_complete", as: :user_verify_paypal_complete
  get ':slug/verify/sms/send', to: "twilio#sms_send", as: :user_verify_phone, via: [:get, :post]
  get ':slug/verify/sms/code'=> "twilio#sms_code", via: [:get]
  get ':slug/verify/sms/complete'=> "twilio#sms_complete", via: [:get]
  get ':slug/messages/:id' => "messages#show", constraints: {id: /[0-9]+/}
  get ':slug/messages/:label' => "messages#index", constraints: {label: /[a-z]+/}

  # landing routes - in the process of being deprecated
  get 'landing/success/:code' => 'landing#success', as: :landing_success
  # get 'landing(/:code)' => 'landing#index', as: :landing
  get 'landing(/:code)' => redirect("/listings/recent"), as: :landing

  get 'listings' => redirect("/listings/recent")
  resources :listings, except: [:show] do
    get :manage, on: :collection
    get :recent, on: :collection
  end
  resources :listing_forms, only: [] do
    get :images, on: :member
    get :new_image, on: :collection
    get :shipping_table, on: :member
    get :subcategories, on: :collection
  end
  resources :listing_modals, only: [] do
    get :crop_image, on: :collection
  end
  resources :listing_reports, only: [:index]

  match 'listings/search' => "listings#by_search", as: :listing_search, via: [:get, :post]
  get 'listings/:category(/:subcategory)' => "listings#by_category", constraints: {category: /[a-z-]+/},
    as: :listing_category
  get 'listings/:id' => "listings#show", constraints: {id: /[0-9]+/}

  resources :stories, only: [:index, :show]
  resources :breeders, only: [:index]

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

  # facebook share
  get 'facebook/share/:klass/:id/auth(/from/:page)', to: "facebook_share#auth", as: :facebook_share_auth
  get 'facebook/share/:klass/:id/share(/from/:page)', to: "facebook_share#share", as: :facebook_share

  # payments
  resources :payments, only: [:index]

  # twilio sms
  match 'sms/reply' => "twilio#sms_reply", as: :twilio_sms_reply, via: [:get, :post]
  match 'sms/manage'=> "twilio#sms_manage", as: :twilio_sms_list, via: [:get]

  # plans
  resources :plans, only: [:index, :show] do
    get :manage, on: :collection
    get :details, on: :member
  end
  resources :reviews, only: []
  resources :waitlists, only: [:index]

  # categories
  resources :categories, only: [:index]

  get 'about/contact' => "about#contact", as: :about_contact
  get 'about/privacy' => "about#privacy", as: :about_privacy
  get 'about/terms' => "about#terms", as: :about_terms
  get 'about/us' => "about#us", as: :about_us

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
