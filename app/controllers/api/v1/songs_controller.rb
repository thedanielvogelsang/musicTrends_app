class Api::V1::SongsController < ApplicationController
  include ParamHelper
  def index
    if params[:query]
      song = GeniusService.new.get_songs(params[:query])
      render json: song, status: 202
    else
      error = "Try a different query, that one's stale"
      render json: {error: error}, status: 404
    end
  end

  def show
    if song = GeniusService.new.get_song_info(params[:song_id])
      render json: song, status: 202, serializer: nil
      MasterSearchJob.perform_async(safe_song(song), safe_search)
    else
      render json: {error: "RecordNotFound"}, status: 404
    end
  end
end
