Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  scope '/api/v1', defaults: { format: :json } do
    resources :references, only: [:index, :show, :create, :destroy] do
      post 'set_from_url', to: 'references#set_from_url'
      post 'add_tag', to: 'references#add_tag'
      post 'remove_tag', to: 'references#remove_tag'
    end 

    resources :tags, only: [:index, :show, :create, :destroy]
  end
end
