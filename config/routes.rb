SampleApp::Application.routes.draw do
  # Adding following and followers actions to the Users controller.
  # the URLs will look like /users/1/following and /users/1/followers
 resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  
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