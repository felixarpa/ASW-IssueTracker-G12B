Rails.application.routes.draw do
  root 'issues#index'
  get 'auth/:provider/callback', to: "sessions#create"
  delete 'sign_out', to: "sessions#destroy", as: 'sign_out'

  resources :issues do
    member do
      resources :vote, only: :create
      resources :watch, only: :create
      resources :comments, except: [:edit, :new], param: :comment_id
    end
  end

  resources :users, only: [:index]
  resources :me, only: [:index]

  get 'issues/:id/attach', to: 'issues#attach', as: :attach_to_issue
  resources :attached_files, only: :destroy
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
