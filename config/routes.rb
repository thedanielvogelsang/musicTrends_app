Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'searches/index'
      get 'searches/show'
      get 'songs/index'
      get 'songs/show'
    end
  end
  namespace :api do
    namespace :v1 do
      resources :tags, only: [:index, :show, :create, :update, :destroy]
    end
  end
    get 'songsearch', to: "searches#index", as: :songsearch, action: :index
    get 'songinfo/:song_id', to: "searches#show", as: :songs, action: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
      end
    end
end
