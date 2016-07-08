Rails.application.routes.draw do
  get '/ping', to: 'ping#index'

  # get '(*all)', to: 'errors#service_unavailable_503'

  ###############
  # error pages #
  ###############

  get '/403', to: 'errors#forbidden_403'
  get '/404', to: 'errors#not_found_404'
  get '/500', to: 'errors#internal_server_error_500'
  get '/503', to: 'errors#service_unavailable_503'

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

  ############
  # sonar v3 #
  ############

  post '/fleets/datatable_views', to: 'datatable_views#create'
  get '/fleets/datatable_views/:id/', to: 'datatable_views#show', as: 'datatable_view'
  post '/fleets/datatable_views/:id/edit', to: 'datatable_views#update'
  post '/fleets/datatable_views/:id/delete', to: 'datatable_views#destroy'

  resources :fleets do
    collection do
      get 'export'
    end
  end

  namespace :reports do
    resources :reports, controller: :reports, only: [:index]
    resources :forecasts, controller: :forecasts, only: [:index]
  end

  resources :analysis, only: [:index]

  ############
  # sonar v2 #
  ############

  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/trends', to: 'trends#index', as: 'trends'
  get '/comparisons', to: 'comparisons#index', as: 'comparisons'
  get '/demo', to: 'demo#index', as: 'demo'

  # needs to come before the resources call, to get match priority
  namespace :customers do
    resource :upload, controller: :upload, only: [:show, :create]
  end
  resources :customers

  namespace :settings do
    resource :send, controller: :send, only: [:show, :update]
    resource :view, controller: :view, only: [:show, :update]
  end

  namespace :setup do
    get :embed
    get :api
  end

  namespace :admin do
    resource :users, controller: :users, only: [:show, :update, :destroy]
  end

  resources :responses

  ############
  # sonar v1 #
  ############

  get '/videos.json', to: 'videos_json#show'
  get '/create', to: 'drafts#new' # so it doesn't highlight the left nav
  post '/create', to: 'drafts#create'
  get '/share/videos/:id', to: 'share_videos#show', as: 'share_videos'
  get '/results/:id/edit', to: 'drafts#edit'
  patch '/results/:id/edit', to: 'drafts#update'
  get '/feedback/videos/:id', to: 'feedback#show', as: 'feedback_videos'

  resources :transcripts
  resources :notes
  resources :highlights
  resources :studies do
    resources :step, only: [:create], controller: 'studies_step'
    resources :video, only: [:create, :update], controller: 'studies_video'
  end
  resources :drafts
  resources :recent, only: [:index]
  resources :results do
    resources :videos, only: [:show], controller: 'results'
  end
  resources :feedback, controller: 'feedback'

  ################
  # shared login #
  ################

  devise_for :user,
    path_names: { sign_in: 'login', sign_out: 'logout' },
    controllers: { registrations: 'registrations', invitations: 'invitations' }

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:super_admin?) && current_user.super_admin?
  end

  ResqueWeb::Engine.eager_load!
  constraints resque_web_constraint do
    mount ResqueWeb::Engine => '/resque'
  end

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
