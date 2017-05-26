Rails.application.routes.draw do
  root 'issues#index', via: :options
  get 'auth/:provider/callback', to: "sessions#create", via: :options
  delete 'sign_out', to: "sessions#destroy", as: 'sign_out', via: :options

  resources :issues do
    member do
      resources :vote, only: :create, via: :options
      resources :watch, only: :create, via: :options
      resources :comments, except: [:edit, :new], param: :comment_id, via: :options
    end
  end

  resources :users, only: [:index], via: :options
  resources :me, only: [:index], via: :options

  get 'issues/:id/attach', to: 'issues#attach', as: :attach_to_issue, via: :options
  resources :attached_files, only: :destroy, via: :options
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
