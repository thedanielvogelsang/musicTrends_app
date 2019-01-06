class MasterSearchJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(song_params, search_params)
    begin
    song = Song.find_or_create_by(song_params)
    rescue
      raise ActiveRecord::RecordNotFound
    end
    begin
    search = Search.find_or_create_by(search_params)
    rescue
      raise ActiveRecord::RecordNotFound
    end
    song = Song.find_or_create_by(song_params)
    search = Search.find_or_create_by(search_params)
  end
end
