Rails.application.routes.draw do
    get 'search_songs', to: "api/v1/songs#index", as: :search_songs, action: :index
    get 'songs/:song_id', to: "api/v1/songs#show", as: :songs, action: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
      end
    end
end
