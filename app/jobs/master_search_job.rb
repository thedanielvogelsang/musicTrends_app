class MasterSearchJob
  include SongSearchHelper
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(song_params, search_params)
    begin
    song = Song.find_or_create_by(id: song_params["id"])
    rescue
      ActiveRecord::Base.connection.execute 'ROLLBACK'
      raise ActiveRecord::RecordNotUnique
    end
    begin
    search = Search.find_or_create_by(search_params)
    rescue
      ActiveRecord::Base.connection.execute 'ROLLBACK'
      raise ActiveRecord::RecordNotFound
    end
    if song && search
      song.update(song_params)
      sync_song_and_search(song.id, search.id)
      trends = SongWorker.confirm_referents_sync_song_and_find_trends(song.id)
      SearchWorker.new(search.id).create_keywords
    end
  end
end
