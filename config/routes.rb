ActionController::Routing::Routes.draw do |map|
  map.resources :consignments, :member => { :delete => :get }
  map.resources :card_transactions
  map.resources :card_infos, :member => { :delete => :get }
  map.resources :invoices, :member => { :delete => :get }
  map.resources :reports
  map.resources :accounts
  map.resources :liability_limits, :member => { :delete => :get }
  map.resources :flag_for_users, :member => { :delete => :get }
  map.resources :how_heards, :member => { :delete => :get }
  map.resources :integrities, :member => { :delete => :get }
  map.resources :timelinesses, :member => { :delete => :get }  
  map.resources :creditworths, :member => { :delete => :get }  
  map.resources :feedbacks, :member => { :delete => :get }
  map.resources :call_results
  map.resources :answers
  map.resources :alerts
  map.resources :contacts
  map.resources :prospects
  map.resources :affiliations
  map.resources :bluebook_members
  map.resources :bids
  map.resources :watched_locations
  map.resources :industry_roles, :member => { :delete => :get }
  map.resources :addresses, :member => { :delete => :get }
  map.resources :phones, :member => { :delete => :get }
  map.resources :tag_for_addresses, :member => { :delete => :get }
  map.resources :tag_for_phones, :member => { :delete => :get }

  # without this, you'll get an error on "foods/new" but not "foods/edit"
  map.connect 'foods/food_tree_live_tree_data', :controller => 'foods', 
                :action => 'food_tree_live_tree_data'
  map.resources :foods,
                :member => { :food_tree_live_tree_data => :get }
  map.resources :treatments, :member => { :delete => :get }
  map.resources :certifications, :member => { :delete => :get }
  map.resources :conditions, :member => { :delete => :get }
  map.resources :qualities, :member => { :delete => :get }
  map.resources :per_cases, :member => { :delete => :get }
  map.resources :packs, :member => { :delete => :get }
  map.resources :sizes, :member => { :delete => :get }
  map.resources :growns, :member => { :delete => :get }
  map.resources :colors, :member => { :delete => :get }
  map.resources :weights, :member => { :delete => :get }
  # adds additional route to usual RESTful routes: /invitation_codes/1;invite
  map.resources :invitation_codes
  map.resources :members
  map.resources :administrators
  map.resources :roles, :member => { :delete => :get }
  map.resources :guests
  map.resources :auctions, :member => { :quickcopy => :get }  do |auction|
                auction.resources :assets, :member => { :delete => :get }
                end
  map.resources :organizations, :member => { :delete => :get } do |organization|
                organization.resources :logos, :member => { :delete => :get }
                organization.resources :phones
                organization.resources :addresses
                end
  map.resources :users do |user|
                user.resources :mugshots, :member => { :delete => :get }
                user.resources :permissions
                user.resources :phones
                user.resources :addresses
                end
  # Note the singular form for session. Each user can only have one session at a time so it is singular
  map.resource :session
  # makes it possible to request '/admin/users' as well as '/users'
  # (not really necessary but makes for more obvious URLs)
  map.connect 'admin', :controller => 'admin/home', :action => 'index'
  map.resource :admin do |admin| 
                admin.resources :roles, :name_prefix => 'admin_'
                admin.resources :users, :name_prefix => 'admin_'
                admin.resources :mugshots, :path_prefix => 'admin', :controller => 'admin/mugshots'
                admin.resources :auctionphotos, :path_prefix => 'admin', :controller => 'admin/auctionphotos'
                end
  # avoid errors generated by some scripts probing for security exploits
  map.connect 'admin.php', :controller => 'admin/home', :action => 'show'
                
  # named routes for the Auction system
  map.privacy '/foodmoves/privacy', :controller => 'foodmoves/privacy', :action => 'index'
  map.contact_us '/foodmoves/contact', :controller => 'foodmoves/contact_us', :action => 'index'
  map.legal '/foodmoves/legal', :controller => 'foodmoves/legal', :action => 'index'
  map.about '/foodmoves/about', :controller => 'foodmoves/about', :action => 'index'
  map.start '/foodmoves/start', :controller => 'foodmoves/start', :action => 'index'
  map.news '/news', :controller => 'news', :action => 'index'
  map.buy '/buy', :controller => 'buy', :action => 'index'
  map.sell '/sell', :controller => 'sell', :action => 'index'
  
  # some additional named routes for the Authentication system
  map.signup '/signup', :controller => 'guests', :action => 'new'
  map.login  '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'

  # route for default home page
  map.home '', :controller => 'home', :action => 'index'

  # route for default home page (Rails 2.0 style)
  map.root :controller => 'home'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  # COMMENT OUT to restrict all requests to named routes only
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
