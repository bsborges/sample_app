SampleApp::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  
  root to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  # get 'exit', to: 'sessions#destroy', as: :logout
  # This will create logout_path and logout_url as named helpers in your application. Calling logout_path will return /exit
  
end