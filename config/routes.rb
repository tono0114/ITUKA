Rails.application.routes.draw do

  get "top", :to => "homes#top"

  devise_for :users
  resources :users, except: [:create, :new]
  get "users/:id/unsubscribe", :to => "users#unsubscribe", as: "user_unsubscribe"

  devise_scope :user do
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    delete "logout", :to => "users/sessions#destroy"
  end

  resources :posts, except:[:edit]
  get "posts/:id/delete_confirm", :to => "posts#delete_confirm", as: "post_delete_confirm"

  resources :post_comments, only:[:create, :destroy]

  resources :favorites, only:[:create, :destroy]

  resources :relationships, only:[:create, :destroy]
  get "followings", :to => "relationships#followings"
  get "followers", :to => "relationships#followers"

end
