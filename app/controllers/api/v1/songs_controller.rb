class Api::V1::SongsController < ApplicationController
  include ParamHelper
  def index
    if params[:query]
      paginate json: GeniusService.new.get_songs(params[:query]), status: 202, per_page: 10
    else
      error = "Try a different query, that one's stale"
      render json: {error: error}, status: 404
    end
  end

  def show
    if song = GeniusService.new.get_song_info(params[:song_id])
      render json: song, status: 202
      MasterSearchJob.perform_async(safe_song(song), safe_search)
    else
      render json: {error: "RecordNotFound"}, status: 404
    end
  end

  private

end
