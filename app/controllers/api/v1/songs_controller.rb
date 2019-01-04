class Api::V1::SongsController < ApplicationController
  def index
    if params[:query]
      render json: GeniusService.new.get_songs(params[:query]), status: 202
    else
      error = "Try a different query, that one's stale"
      render json: {error: error}, status: 404
    end
  end

  def show
    if params[:song_id]
      song = GeniusService.new.get_song_info(params[:song_id])
      render json: song, status: 202
    else
      render json: {error: "Record not found."}, status: 404
    end
  end
end
