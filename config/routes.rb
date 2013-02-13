Letsjock::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :sports
  resources :competitions, only: [:create, :update, :destroy]
  resources :teams, only: [:create, :update, :destroy]
  resources :trains, only: [:create, :update, :destroy]
  resources :results, only: [:create, :update, :destroy]
  resources :recognitions, only: [:create, :update, :destroy]
  resources :trainees, only: [:create, :update, :destroy]
  resources :works, only: [:create, :update, :destroy]
  resources :educations, only: [:create, :update, :destroy]
  resources :photos, only: [:create, :update, :destroy]
  resources :videos, only: [:create, :update, :destroy]
  resources :events
  resources :messages, only: [:create, :show]
  resources :relationships, only: [:create, :destroy]
  resources :posts

  root :to => 'home#index'

  match '/signup',  to: 'users#new', :as => :signup
  match '/signin',  to: 'sessions#new', :as => :signin
  match '/signout', to: 'sessions#destroy', :as => :signout
  match '/profile/:id', to: 'users#profile'
  match '/profile/:id/social', to: 'users#social', :as => :social
  match '/profile/:id/add_new', to: 'users#add_new', :as => :add_new
  match '/events/:id/join' => 'events#join', :as => :join
  match '/events/:id/new_admin' => 'events#new_admin', :as => :event_new_admin
  match '/inbox', to: 'messages#inbox', :as => :inbox
  match '/inbox/new', to: 'messages#new', :as => :new_message
  match '/profile/:id/follow' => 'relationships#create', :as => :follow
  match '/profile/:id/unfollow' => 'relationships#destroy', :as => :unfollow


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
