Rails.application.routes.draw do
  get 'searches/index', to: "api/v1/searches#index"
  get 'searches/:id', to: "api/v1/searches#show"
  get 'songs', to: "api/v1/songs#index"
  get 'songs/:id', to: "api/v1/songs#show"

  namespace :api do
    namespace :v1 do
      resources :tags, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get 'songsearch', to: "searches#index", as: :songsearch, action: :index
  get 'songinfo/:song_id', to: "searches#show", action: :show
end
