Rails.application.routes.draw do
  root to: 'static_page#home'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get "home", to: 'users#home'

  resources :users, only: %i[new create]
  resources :posts
end
