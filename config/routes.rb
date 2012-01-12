SampleApp::Application.routes.draw do

  get "sessions/new"

  resources :users
  resources :sessions, :only => [:new, :destroy, :create]
  resources :microposts, :only => [:create, :destroy]

  root :to => "pages#home"
  
  match '/contact', :to => "pages#contact"
  match '/help', :to => "pages#help"
  match '/about', :to => "pages#about"
  match '/signup', :to => "users#new"
  match '/signin', :to => "sessions#new"
  match '/signout', :to => "sessions#destroy"

end
