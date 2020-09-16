Workarea::Storefront::Engine.routes.draw do
  get 'logo.htm', to: 'kount#data_collector', as: 'kount_data_collector_htm'
  get 'logo.gif', to: 'kount#data_collector', as: 'kount_data_collector_gif'

  post 'kount_orders', to: 'kount_orders#bulk'
end

Workarea::Admin::Engine.routes.draw do
  resources :orders, only: [] do
    member do
      get :kount
    end
  end
end
