Letsjock::Application.routes.draw do
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :sports
  resources :competitions, :only => [:create, :update, :destroy]
  resources :teams, :only => [:create, :update, :destroy]
  resources :trains, :only => [:create, :update, :destroy]
  resources :results, :only => [:create, :update, :destroy]
  resources :recognitions, :only => [:create, :update, :destroy]
  resources :trainees, :only => [:create, :update, :destroy]
  resources :works, :only => [:create, :update, :destroy]
  resources :educations, :only => [:create, :update, :destroy]
  resources :photos
  resources :videos, :only => [:create, :update, :destroy]
  resources :events
  resources :messages, :only => [:create, :show]
  resources :relationships, :only => [:create, :destroy]
  resources :posts

  root :to => 'home#index'

  match '/beta' => 'home#beta', :as => :beta
  match '/about' => 'about#index', :as => :about
  match '/about/contact' => 'about#contact', :as => :contact_us
  match '/news' => 'feed#index', :as => :news
  match '/welcome' => 'welcome#index', :as => :welcome
  match '/signup' => 'users#new', :as => :signup
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/profile/:id' => 'users#profile', :as => :profile
  match '/profile/:id/social' => 'users#social', :as => :social
  match '/profile/:id/pictures' => 'users#pictures', :as => :pictures
  match '/profile/:id/add_new' => 'users#add_new', :as => :add_new
  match 'profile/:id/add_new_working' => 'users#add_new_working', :as => :add_new_working
  match 'profile/:id/add_new_educational' => 'users#add_new_educational', :as => :add_new_educational
  match '/profile/:id/edit_profile' => 'users#edit_profile', :as => :edit_profile
  match '/profile/:id/remove_profile' => 'users#remove_profile', :as => :remove_profile
  match '/notification/:id' => 'users#read_notification', :as => :follow_notification
  match '/search' => 'users#search', :as => :search
  match '/events/:id/join' => 'events#join', :as => :join
  match '/events/:id/disjoin' => 'events#disjoin', :as => :disjoin
  match '/events/:id/new_admin' => 'events#new_admin', :as => :event_new_admin
  match '/inbox'=> 'messages#inbox', :as => :inbox
  match '/inbox/new'=> 'messages#new', :as => :new_message
  match '/profile/:id/follow' => 'relationships#create', :as => :follow
  match '/profile/:id/unfollow' => 'relationships#destroy', :as => :unfollow
  match '/profile/:id/change_profile_pic' => 'users#change_profile_pic', :as => :change_profile_pic
  match '/profile/:id/change_bg_pic' => 'users#change_bg_pic', :as => :change_bg_pic
  match '/profile/:id/email_authentication/:token' => 'users#auth_email', :as => :auth_email
  match '/newprofile' => 'users#profile_new', :as => :newprofile
  match '/newsponsor' => 'users#sponsor_new', :as => :new_sponsor
  match '/createsponsor' => 'users#sponsor_create', :as => :create_sponsor
  match '/forgotten_password' => 'users#forgotten_password', :as => :forgotten_password
  match '/new_password_request' => 'users#new_password_request', :as => :new_password_request
  match '/confirmed_new_password/:token' => 'users#confirmed_new_password', :as => :confirmed_new_password
  match '/change_password' => 'users#change_password', :as => :change_password
  match '/profile/:id/edit_sponsor' => 'users#sponsor_edit', :as => :edit_sponsor
  match '/profile/:id/new_event' => 'events#new', :as => :new_event
  match '/settings' => 'settings#index', :as => :settings
  match '/forgotten_password' => 'users#forgotten_password', :as => :forgotten_password
  match '/new_password_request' => 'users#new_password_request', :as => :new_password_request
  match '/confirmed_new_password/:token' => 'users#confirmed_new_password', :as => :confirmed_new_password
  match '/change_password' => 'users#change_password', :as => :change_password
  match '/new_password_form' => 'settings#new_password_form', :as => :new_password_form
  match '/invite' => 'users#invite', :as => :invite
  match '/send_mail_auth' => 'users#send_mail_auth', :as => :send_mail_auth
  match '/follow_letsjock' => 'users#follow_letsjock', :as => :follow_letsjock


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
