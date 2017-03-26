Rails.application.routes.draw do
  root 'static_pages#home'

  #get '/catapult', to: 'static_pages#catapult'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/auth/spotify/callback', to: 'users#spotify'

  resources :users, except: [ :index ] do
    member do
      patch :adminify
    end
  end

  resources :account_activations, only: [ :edit ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  resources :bands, except: [ :show, :edit ]
  get "bands/:provider/:provider_id", to: "bands#show", as: :provider_band
  get "bands/:provider/:provider_id/edit", to: "bands#edit", as: :edit_provider_band

  resources :band_likes, only: [ :create, :destroy ]

  get '/chooser', to: "choose#chooser", as: :chooser
  get '/choose', to: "choose#choose", as: :choose

  scope '/admin' do
    get '/', to: "admin#home", as: :admin_home
    get '/users', to: "admin#users", as: :admin_users
    get '/bands', to: "admin#bands", as: :admin_bands
  end
end
