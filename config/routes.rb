Rails.application.routes.draw do



  get 'feeds/home'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    resources :friendships, :path => "friends"

  end

post '/users/:id/parse_add_friend_form_data', to: 'users#parse_add_friend_form_data', as:'parse_form_data'


  resources :transactions, only: [:create, :new, :index]
  resources :friendships, only: [:create, :new, :index, :edit, :update]
  resources :relationships, only: [:create, :new, :index]


  get '/users/:id/edit_balance', to: 'users#edit_balance', as:'edit_balance'
  post '/users/:id/edit_balance', to: 'users#update_balance',  as:'update_balance'

  get '/users/:id/add_friends', to: 'users#add_friends', as:'add_friends'

  get '/users/:id/update_friends', to: 'users#update_friends', as: 'update_friends'
  post '/users/:id/post_update_friends', to: 'users#post_update_friends', as: 'post_update_friends'
  # post '/users/:id/add_friends', to: 'users#update_friends', as:'update_friends'

  get '/users/:id/friend_relationship/:id', to: 'users#friend_relationship', as:'friend_relationship'


  root 'feeds#home'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
