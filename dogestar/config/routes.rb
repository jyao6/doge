Dogestar::Application.routes.draw do
  root 'services#index' #TODO: replace

  # match '/newservice', to: 'services#new', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  resources :users
  resources :services do
    resources :transactions, only: [:new, :create] do
      resources :reviews, only: [:new, :create, :destroy]
    end
    resources :photos, only: [:new, :create, :index, :destroy]
    match '/choose_cover', to: 'photos#choose_cover', via: 'get', as: 'choose_cover'
    match '/make_cover/:id', to: 'photos#make_cover', via: 'post', as: 'make_cover'
    match '/remove_photos', to: 'photos#remove', via: 'get', as: 'remove_photos'
  end
  resources :sessions, only: [:new, :create, :destroy]
  match '/signup', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'get'
  get '/forgot-password', to: 'users#forgot_password', as: 'forgot_password'
  post '/forgot-password', to: 'users#request_reset'
  match '/reset-password', to: 'users#reset_password',     via: ['get', 'post'], as: 'reset_password'
  match '/change-password', to: 'users#change_password',     via: ['get', 'post'], as: 'change_password'
  match '/history', to: 'transactions#history',     via: ['get', 'post'], as: 'order_history'
  match '/cancel/:id', to: 'transactions#cancel',     via: ['get', 'post'], as: 'cancel_order'
  match '/upcoming', to: 'transactions#upcoming',     via: ['get', 'post'], as: 'upcoming'
  match '/clear-notifications', to: 'notifications#clear',     via: ['get', 'post'], as: 'clear_notifications'
  match '/notifications', to: 'notifications#index',     via: ['get', 'post'], as: 'notifications'

  match '/messages/:other_id', to: 'messages#new', via: ['get'], as: 'messages'
  match '/messages/:other_id', to: 'messages#create', via: ['post']
  match '/inbox', to: 'messages#index', via: ['get'], as: 'inbox'
  match '/outbox', to: 'messages#index_sent', via: ['get'], as: 'outbox'

  match 'services/filter', to: 'services#filter', via: ['post']
  match 'services/search', to: 'services#search', via: ['post', 'get']
  get 'services/:id/reviews' => 'services#show_reviews'


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
