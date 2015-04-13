Rails.application.routes.draw do
  get '/login',       to: 'sessions#index', as: :login
 post '/login/new',   to: 'sessions#create', as: :new_login
  get '/logout',      to: 'sessions#destroy', as: :logout
  get '/account',     to: 'account#index'
  get '/videos.json', to: 'videos_json#show'
  get '/create',      to: 'drafts#new'
  get '/my_results',  to: 'results#my_index'
  get '/recent',      to: 'recent#index'
  get '/create',      to: 'create#index'
  get '/studies/:id', to: 'user_scenarios#index'
 post '/studies/new', to: 'user_scenarios#new'
  get '/share/videos/:id', to: 'share_videos#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :drafts
  resources :results
  resources :my_results, controller: 'results'

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
