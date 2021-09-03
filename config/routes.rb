Rails.application.routes.draw do

  get "top" => "homes#top"

  devise_for :users
  resources :users, except: [:create, :new] do
    collection do
      get "search"
    end
  end
  get "unsubscribe/:id" => "users#unsubscribe", as: "user_unsubscribe"

  devise_scope :user do
    get "signup" => "users/registrations#new"
    get "login" => "users/sessions#new"
    delete "logout" => "users/sessions#destroy"
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  delete 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get "followings/:id", :to => "relationships#followings", as: "followings"
  get "followers/:id", :to => "relationships#followers", as: "followers"

  resources :posts, except:[:edit] do
    resource :favorites, only:[:create, :destroy]
    collection do
      get "search"
    end
  end
  get "delete_confirm/:id" => "posts#delete_confirm", as: "delete_confirm"

  resources :post_comments, only:[:create, :destroy]

end
