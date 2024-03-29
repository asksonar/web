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

  resources :aircraft do
    get 'export', on: :collection
    resources :history, controller: 'aircraft_history'
  end

  scope '/aircraft' do
    resources :views, only: [:create, :show, :destroy], controller: 'datatable_views', as: 'datatable_views'
  end

  resources :analysis, only: [:index]

  scope '/analysis' do
    resources :views, only: [:create, :show, :destroy], controller: 'analysis_views', as: 'analysis_views'
  end

  namespace :reports do
    resources :aircraft_reports, controller: :aircraft_reports, only: [:index]
    resources :forecasts, controller: :forecasts, only: [:index]
  end

  namespace :admin do
    resource :users, controller: :users, only: [:show, :update, :destroy]
  end

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
