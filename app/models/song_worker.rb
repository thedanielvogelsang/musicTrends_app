class SongWorker
  attr_reader :song_id, :refs

  def initialize(song_id)
    @song_id = song_id
    @refs = GeniusService.new.get_referents(song_id)
  end

  def update_or_create_word_list
    song = Song.find(@song_id)
    word_count = song.word_dict
    @refs.each do |ref|
      ref = ref[:annotations][0][:body][:dom][:children][0][:children]
      wrd_cnt = WordCounter.new("Song", @song_id, ref).count_words
      wrd_cnt.each do |k, v|
        word_count[k] ? word_count[k] += v : word_count[k] = v
      end
    end
    song.word_dict = word_count
    song.save
  end

end
