Olympic::Application.routes.draw do
  devise_for :users
  root to: "main#index"
  devise_for :admins, controllers: { sessions: "admin/sessions" }
  namespace :admin do
    root to: 'users#index'
    resources :messages
    resources :groups
    resources :posts
    resources :users do
      get :login
    end
  end
  resources :main, only: [:index]
  resources :assets
  resources :messages
  resources :invitations 
  resources :users do
    get :complite, on: :collection
    post :set_locale, on: :collection
    get :invite_friend, on: :member
    get :reject_friend, on: :member
    resources :posts do
      member do 
        post :like
        post :dislike
        post :restore
      end
    end 
  end
  resources :chats, only: :create
  resources :groups do
    resources :posts do
      member do 
        post :like
        post :dislike
        post :restore
      end
    end
    post :entry, on: :member
    delete :exit, on: :member
  end
end
