Rails.application.routes.draw do

  get "/", :to => "homes#top"

  devise_for :users
  resources :users

  devise_scope :user do
    get "sign_up", :to => "users/registrations#new"
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
  end

  resources :posts, except:[:edit]
  get "posts/:id/delete_confirm", :to => "posts#delete_confirm"

  resources :post_comments, only:[:create, :destroy]

  resources :favorites, only:[:create, :destroy]

  resources :relationships, only:[:create, :destroy]
  get "followings", :to => "relationships#followings"
  get "followers", :to => "relationships#followers"

end
