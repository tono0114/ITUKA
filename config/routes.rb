Rails.application.routes.draw do

  root "homes#top"
  get "about" => "homes#about"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users, except: [:create, :new] do
    get "unsubscribe/:id" => "users#unsubscribe", as: "unsubscribe"
    collection do
      get "search"
    end
  end

  devise_scope :user do
    get "signup" => "users/registrations#new"
    get "login" => "users/sessions#new"
    delete "logout" => "users/sessions#destroy"
    post "guest_sign_in" => "users/sessions#guest_sign_in"
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  delete 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get "followings/:id", :to => "relationships#followings", as: "followings"
  get "followers/:id", :to => "relationships#followers", as: "followers"

  resources :posts do
    resource :favorites, only:[:create, :destroy]
    resources :post_comments, only:[:create, :destroy]
    get "delete_confirm/:id" => "posts#delete_confirm", as: "delete_confirm"
    collection do
      get "search"
    end
  end
end
