Flixter::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of singleton route - it's used to represent a resource that only
  # exists once in it's given context
  # note we use 'resource', no 's', and dashboard
  # is singular (though it will still know how to connect to the dashboards
  # controller...?)
  resource :dashboard, only: [:show]
  
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'static_pages#index'
  get 'privacy', to: 'static_pages#privacy'
  get 'team', to: 'static_pages#team'
  get 'careers', to: 'static_pages#careers'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :courses, only: [:index, :show] do
    resources :enrollments, only: :create
  end
  
  resources :lessons, only: [:show]

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
  namespace :instructor do
    # these two are for the drag-and-drop AJAX POST request routes
    resources :lessons, only: [:update]
    resources :sections, only: [:update]

    # indicates we're dealing with resources for sections, 
    # but don't hook up any actions to the route (note empty []).
    # makes it so the URLs include the section_id, but not 
    # the course_id, which now prevents a user from adding lessons 
    # to a mismatched course & section via the URL pattern
    resources :sections, only: [] do
      resources :lessons, only: [:create]
    end
    resources :courses, only: [:new, :create, :show] do
      resources :sections, only: [:create]
    end
  end
  
end
