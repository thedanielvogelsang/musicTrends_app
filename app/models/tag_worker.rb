class TagWorker
  attr_accessor :tag_id
  def initialize(tag_id)
    @tag_id = tag_id
  end
  def self.add_tag_to_song(tag_id, song_id)
    song = SongTagging.find_or_create_by(tag_id: tag_id, song_id: song_id)
  end
end
