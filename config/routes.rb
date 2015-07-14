Rails.application.routes.draw do

  root 'home#index'

  resources :restaurants do
    resources :items
    resources :orders
    resources :categories
    resources :user_roles, only: [:new, :index, :create]
  end

  resources :addresses

  get 'code', to: 'welcome#code'

  get 'complete_delivery_order', to: 'orders#create'
  get 'checkout',         to: 'checkouts#show'
  get 'complete_order',   to: 'checkouts#complete_order'

  get 'cart',             to: 'carts#show',           as: 'cart'
  get 'add_item',         to: 'carts#add_item',       as: 'add_item'
  get 'remove_item',      to: 'carts#remove_item',    as: 'remove_item'
  put 'update_quantity',  to: 'carts#update_quantity',as: 'update_quantity'

  resources :users do
    resources :online_orders, only: [:index, :show, :new, :create]
  end

  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'


  resources :home

  get 'verification', to: 'verifications#show'


  get 'gift_cards', to: 'gift_cards#show'
  get 'about',      to: 'about#show'
  match '/contact_us',     to: 'contact_us#new',             via: 'get'
  resources "contact_us", only: [:new, :create]

end
