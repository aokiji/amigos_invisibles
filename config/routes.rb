Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :personas, only: [:index, :show, :update]

  match 'personas/shuffle', to: 'personas#shuffle', via: :post

  root 'application#home'
end
