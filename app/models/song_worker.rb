class SongWorker
  attr_reader :song_id, :ref

  def initialize(song_id)
    @song_id = song_id
    @ref = GeniusService.new.get_referents(song_id)
  end
end
