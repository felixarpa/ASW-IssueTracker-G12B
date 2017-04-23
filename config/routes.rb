Rails.application.routes.draw do
  root 'home#index'
  get 'home/profile' => 'home#profile'
  get 'auth/:provider/callback', to: "sessions#create"
  delete 'sign_out', to: "sessions#destroy", as: 'sign_out'
  
  resources :issues do
    member do
      resources :vote, only: :index
    end
  end
  get 'issues/index' => 'issues#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
