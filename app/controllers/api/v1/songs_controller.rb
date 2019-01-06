class Api::V1::SongsController < ApplicationController
  def index
    if params[:query]
      paginate json: GeniusService.new.get_songs(params[:query]), status: 202, per_page: 10
    else
      error = "Try a different query, that one's stale"
      render json: {error: error}, status: 404
    end
  end

  def show
    if params[:song_id]
      song = GeniusService.new.get_song_info(params[:song_id])
      render json: song, status: 202
      MasterSearchJob.perform_async(safe_song(song), safe_search)
    else
      render json: {error: "Record not found."}, status: 404
    end
  end

  private

    def safe_song(song)
      return {
          title: song[:full_title],
          artist_name: song[:album][:artist][:name],
          artist_id: song[:album][:artist][:id],
          annotation_ct: song[:annotation_count]
        }
    end

    def safe_search
      params.require(:search).permit(:text, :search_type)
    end
end
