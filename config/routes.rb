Rails.application.routes.draw do
  root 'static_pages#home'

  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'

  resources :users
end
