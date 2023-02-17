Rails.application.routes.draw do
  root to: 'static_page#home'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get "home", to: 'users#home'
  post '/guest_login', to: 'user_sessions#guest_login'

  resources :users, only: %i[new create show]
  resources :posts do
    resource :favorites, only: [:create, :destroy]
 end
end
