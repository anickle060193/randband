Rails.application.routes.draw do
  root 'static_pages#home'

  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/auth/spotify/callback', to: 'users#spotify'

  resources :users, except: [ :index ]

  resources :account_activations, only: [ :edit ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  resources :bands, except: [ :show, :edit ]
  get "bands/:provider/:provider_id", to: "bands#show", as: :provider_band
  get "bands/:provider/:provider_id/edit", to: "bands#edit", as: :edit_provider_band

  resources :band_likes, only: [ :create, :destroy ]

  resources :choose, only: [ :index ]
end
