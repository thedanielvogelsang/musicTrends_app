Rails.application.routes.draw do
  get 'searches/index', to: "api/v1/searches#index"
  get 'searches/:id', to: "api/v1/searches#show"
  get 'songs', to: "api/v1/songs#index"
  get 'songs/:id', to: "api/v1/songs#show"

  get 'tags', to: "api/v1/tags#index"
  get 'tags/:id', to: "api/v1/tags#show"
  post 'tags', to: "api/v1/tags#create"
  put 'tags/:id', to: "api/v1/tags#update"
  delete 'tags/:id', to: "api/v1/tags#destroy"

  get 'songsearch', to: "searches#index", as: :songsearch, action: :index
  get 'songinfo/:song_id', to: "searches#show", action: :show
end
