Rails.application.routes.draw do
  get 'home#index'
  get 'home#profile'
  
  resources :issues
  root 'issues#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
