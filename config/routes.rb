Mijikai::Application.routes.draw do
  match "favorites/create" => "favorites#create", :as => 'create_favorite'
  match "favorites/destroy" => "favorites#destroy", :as => 'destroy_favorite'

  # Only allow test users to sign in and out
  devise_for :test_users, :only => :sessions, :controllers => {:sessions => "test_users/sessions"}

  resources :resources
  resources :topics, :only => [:index]

  #facebook login
  devise_scope :user do
     get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru' 
  end
  #devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  #end facebook login

  devise_for :user, :path => '', :path_names => { :sign_in => "sign_in", :sign_out => "sign_out", :sign_up => "register" }, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  #devise_for :users, :controllers => { :registrations => "users/registrations" }

  # Allow download of file only to signed in users
  match "/uploads/:id/:basename.:extension", :controller => "resources", :action => "download", :conditions => { :method => :get }, :as => 'resource_download'
  match "/tmp/cache/:id/:basename.:extension", :controller => "resources", :action => "download_cached_attachment", :conditions => { :method => :get }

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  scope :controller => :pages do
    match 'about' => :about, :as => 'about'
    match 'contact' => :contact, :as => 'contact'
    match 'send_contact_mail' => :send_contact_mail
    match 'mail_sent_confirmation' => :mail_sent_confirmation, :as => 'mail_sent_confirmation'
    match 'help' => :help, :as => 'help'
    match 'privacy' => :privacy, :as => 'privacy'
    match 'terms' => :terms, :as => 'terms'
    match 'unauthorized' => :unauthorized, :as => 'unauthorized'
  end

  #user
  match 'account' => 'users#account', :as => 'account'
  match 'favorites' => 'favorites#index', :as => 'favorites'
  
  #topic
  #match '/topics' => 'topics#index', :as => 'topics'
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#home'

  match '*something' => 'pages#not_found'
=begin
  #COMING SOON 
  #match '*something', :to => redirect('/coming_soon.html')
  #root :to => redirect('/coming_soon.html')
  match 'coming_soon_confirmation' => 'pages#coming_soon_confirmation', :as => 'coming_soon_confirmation'
  match 'submit_email_coming_soon' => 'pages#submit_email_coming_soon'
  match '*something' => 'pages#coming_soon'
  root :to => 'pages#coming_soon'
=end
=begin
  #MAINTENANCE
  match '*something', :to => redirect('/maintenance.html')
  root :to => redirect('/maintentance.html')
=end
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
