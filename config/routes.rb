MongoPractice::Application.routes.draw do
  get 'admin' => "admin#index"

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users, :line_items, :carts
  resources :orders, :except => [:edit, :update]

  resources :products do
    get :who_bought, on: :member
  end

  root :to => 'store#index' , :as => 'store'
end