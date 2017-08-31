Rails.application.routes.draw do
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post "sign_up", to: 'users#create'
  resources :books, only: [:index, :create, :update]
end
