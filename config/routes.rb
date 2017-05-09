Rails.application.routes.draw do
  root 'issues#index'
  get 'home/profile' => 'home#profile'
  get 'auth/:provider/callback', to: "sessions#create"
  delete 'sign_out', to: "sessions#destroy", as: 'sign_out'
  delete 'delete_issue', to: "issues#destroy", as: 'delete_issue'
  resources :issues do
    member do
      resources :vote, only: :create
      resources :watch, only: :create
      resources :comments, except: [:edit, :new], param: :comment_id
    end
  end
  get 'issues/:id/attach', to: 'issues#attach', as: :attach_to_issue
  resources :attached_files, only: :destroy

  get 'issues/index' => 'issues#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
