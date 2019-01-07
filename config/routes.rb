Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'searches/index'
      get 'searches/show'
    end
  end
  namespace :api do
    namespace :v1 do
      resources :tags, only: [:index, :show, :create, :update, :destroy]
    end
  end
    get 'search_songs', to: "api/v1/songs#index", as: :search_songs, action: :index
    get 'songs/:song_id', to: "api/v1/songs#show", as: :songs, action: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
      end
    end
end
