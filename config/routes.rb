Rails.application.routes.draw do
    get 'search_songs', to: "api/v1/songs_controller#index"
    get 'songs/:song_id', to: "api/v1/songs_controller#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
    end
  end
end
