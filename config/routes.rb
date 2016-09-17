Myapp::Application.routes.draw do


  post '/rate' => 'rater#create', :as => 'rate'
  ##mount Commontator::Engine => '/commontator'

  get 'auth/:provider/callback', to: 'user/sessions#create'
  get 'auth/failure', to: 'user/users#login'#redirect('/user/users/login')
  get 'signout', to: 'application#logout', :as => :signout

  namespace :user do
    resources :sessions, only: [:create, :destroy,:create_dpl_user_by_fb] do
      collection do
        post :create_dpl_user_by_fb
      end
    end
    resources :user_comments
  end


  get "home/index"
  get "home/lab_profile"

  post "home/create_appointment"
  get "home/request_confirmation"
  get "home/download_report"
  post "home/generate_otp", :as => :generate_otp
  post "home/verify_otp", :as => :verify_otp
  #get "home/minor"
  get 'labs/logout' => 'labs#logout', :as => :logout

  get 'static/blog_header_partial' => 'static#blog_header_partial'
  get 'static/blog_footer_partial' => 'static#blog_footer_partial'
  get 'static/blog_copyright_partial' => 'static#blog_copyright_partial'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'dashboard/dashboards#index'

  get 'privacy_policy' => 'home#privacy_policy', :as => :privacy_policy
  get 'about_us' => 'home#about_us', :as => :about_us
  get 'faq' => 'home#faq', :as => :faq
  get 'team' => 'home#team', :as => :team
  match 'contact' => 'home#contact', :as => :contact, via: [:get, :post]

  resources :home do
    collection do
      get :feedback
      post :create_feedback
      #get :faq
      #get :privacy_policy
      #get :about_us
      get :change_password
      post :update_password
    end
  end

  resources :searches do
    collection do
      get :auto_complete
    end
  end

  namespace :dashboard do
    resources :dashboards do
      collection do
        get :populate_graph_ajaxified
        get :list_orders_ajaxified
        get :list_signups_ajaxified
      end
    end
  end


  namespace :admin do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    resources :access
    resources :branches
    resources :admins do
      collection do
        get 'login'
        post 'login'
        get 'register'
      end
    end

    resources :pending_actions do
      collection do
        get 'search'
        get 'get_pending_actions'
        get 'update_ajaxified', :defaults => { :format => 'js' }
      end
    end

    resources :cities do
      collection do
        get 'get_city_details'
        get 'get_location_details'
      end
    end
  end

  namespace :user do
    resources :users do
      collection do
        get 'fetch_user_details'
        post 'login'
        get 'login'
        get 'forgot_password'
        post 'forgot_password'
        get 'user_detail'
        get 'app_user_type'
        get 'app_user_deals'
        get 'business_information'
        get 'addresses'
        get 'personal_details'
      end

      member do
        get 'reset_password'
        post 'reset_password'
      end
    end

    resources :addresses do
      collection do
        get 'search'
      end
    end

    resources :reports do
      collection do
      end
    end
    resources :orders do 
      collection do
      get 'deal_details'
    end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :mobile do
        collection do
          post :register
          post :login
          post :initialize_app
          get :forgot_password
        end
      end
    end
  end

  
  post "/news_letters" => 'news_letters#add_news_letters', as: 'news_letters_add' , :defaults => { :format => 'js' }

  get '/members/login', :to => "user/users#login", :as => :user_login
  get '/members/register', :to => "user/users#new", :as => :user_register
  get '/thankyou', :to => "labs#thankyou", :as => :thankyou
  match '/checkout', :to => "home#checkout", via: [:get, :post]
  #get '/checkout' => "home#checkout", :as => 'checkout'
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
