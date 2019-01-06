class MasterSearchJob
  include SongSearchHelper
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(song_params, search_params)
    begin
    song = Song.find_or_create_by(id: song_params["id"])
    rescue
      raise ActiveRecord::RecordNotUnique
    end
    begin
    search = Search.find_or_create_by(search_params)
    rescue
      raise ActiveRecord::RecordNotFound
    end
    if song && search
      song.update(song_params)
      sync_song_and_search(song.id, search.id)
    end
  end
end
