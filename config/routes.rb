Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount ActionCable.server => '/cable'

  resources :games do
    member do
      post 'move', action: :move
      post 'end-turn', action: :end_turn
      post 'reset'
    end
  end

  resources :sessions, only: %i[create]

  root 'games#index'
end
