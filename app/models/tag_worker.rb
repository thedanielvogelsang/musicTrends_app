class TagWorker
  attr_accessor :tag_id
  def initialize(tag_id)
    @tag_id = tag_id
  end
  def self.add_tag_to_song(tag_id, song_id)
    song = SongTagging.find_or_create_by(tag_id: tag_id, song_id: song_id)
  end
  def match_likely_songs
    tag = Tag.find(@tag_id)
    Song.find_each do |song|
      keywords = tag.keywords.pluck(:phrase)
      keywords.each do |kw|
        song.word_dict.keys.map{|k| k.downcase}.include?(kw) ? create_pos_tag(song.id) : nil
      end
    end
    return Song.joins(:possible_taggings).where(:possible_taggings => {tag_id: @tag_id})
  end
  def create_pos_tag(s_id)
    PossibleTagging.add_or_create_tagging(s_id, @tag_id)
  end
end
