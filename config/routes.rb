Rails.application.routes.draw do
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post "sign_up", to: 'users#create'
  resources :books, only: [:index, :create, :update]

  # あとで削除
  # resources :users
  # scope shallow_prefix: "sign_up" do
  #   post "/sign_up", :to => "users#create"
  # end

end
