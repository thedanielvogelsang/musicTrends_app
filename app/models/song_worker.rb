class SongWorker
  include Words
  attr_reader :song_id, :refs

  def initialize(song_id, refs = nil)
    @song_id = song_id
    @refs = refs
  end

  def get_referents
    @refs = GeniusService.new.get_referents(song_id)
    return self
  end

  def update_or_create_word_dict
    song = Song.find(song_id)
    word_count = song.word_dict
    refs.each do |ref|
      ref = ref[:annotations][0][:body][:dom][:children][0][:children]
      wrd_cnt = WordCounter.new("Song", song_id, ref).count_words
      wrd_cnt.each do |k, v|
        word_count[k] ? word_count[k] += v : word_count[k] = v
      end
    end
    song.word_dict = word_count
    song.save
  end

  def get_referents_and_update_word_dict
    get_referents
    update_or_create_word_dict
  end

  def find_trends
    save_highfreq_words_as_keywords
  end

  def save_highfreq_words_as_keywords
    freq_words_in_dict = Song.find(song_id)
                              .word_dict
                              .select{|k,v| v.to_i > 3}
    freq_words_in_dict.keys.each do |frqword|
      if !CommonWords::WORDS.include?(frqword)
        k = Keyword.find_or_create_by(phrase: frqword)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end
end
