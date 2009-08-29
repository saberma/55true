ActionController::Routing::Routes.draw do |map|
  map.resources :users, :has_many => :messages
  #用户首页
  map.connect '/users/:id/page/:page', :controller => 'users', :action => 'show'
  map.user_question '/users/:id/questions', :controller => 'users', :action => 'questions'
  map.connect '/users/:id/questions/page/:page', :controller => 'users', :action => 'questions'

  map.resource :session

  map.resources :questions
  map.resources :answers
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.home '/', :controller => 'home'
  map.home_member '/member', :controller => 'home', :action => 'member'
  map.connect '/page/:page', :controller => 'home', :action => 'index'

  map.manage_user '/admin/user/:id', :controller => 'admin'

  #用户快捷面板
  map.user_panel '/users/:id/panel', :controller => 'users', :action => 'panel'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
