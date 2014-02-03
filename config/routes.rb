Treebook::Application.routes.draw do
  resources :activities, only: [:index]

  resources :skills


  as :user do 
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users, skip: [:sessions]

  as :user do
    get "/login" => 'devise/sessions#new', as: :new_user_session
    post "/login" => 'devise/sessions#create', as: :user_session
    delete "/logout" => 'devise/sessions#destroy', as: :destroy_user_session
  end



  get "helprequest/ :id(.:format)" => "statuses#help_request", :as => "help_request"

  resources :user_friendships do
    member do
      put :accept
      put :block
    end
  end

  resources :statuses
  get 'feed', to: 'statuses#index', as: :feed
  get 'car_help', to: 'statuses#new_car', :as => "car_help"
  get 'computer_help', to: 'statuses#new_computer', :as => "computer_help"
  root to: 'statuses#index'

  scope ":profile_name" do
    resources :albums do
      resources :pictures
    end
  end

  get '/:id', to: 'profiles#show', as: 'profile'
  get '/:id', to: 'skills#index'


end
