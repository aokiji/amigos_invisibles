Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :personas, only: [:index, :show, :update]

  match 'personas/shuffle', to: 'personas#shuffle', via: :post
  match 'web_components/:component', to: 'application#web_components', via: :get

  root 'application#home'
end
