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

  def update_or_create_word_dict_from_referents
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
    update_or_create_word_dict_from_referents
  end

  def sync_song
    save_highfreq_words_as_keywords
    find_and_match_keywords
  end

  def save_highfreq_words_as_keywords
    freq_words_in_dict = Song.find(song_id)
                              .word_dict
                              .select{|k,v| v.to_i >= 3}
    freq_words_in_dict.keys.each do |frqword|
      if !CommonWords::WORDS.include?(frqword)
        k = Keyword.find_or_create_by(phrase: frqword)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end

  def find_and_match_keywords
    find_and_save_names
    find_and_save_products
    find_and_save_buzzwords
  end

  def find_and_save_products
    song = Song.find(song_id)
    Products::PRODUCTS.each do |word|
      if song.word_dict.keys.include?(word)
        k = Keyword.find__or_create_by(phrase: word)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end

  def find_and_save_buzzwords
    song = Song.find(song_id)
    Buzzwords::BUZZWORDS.each do |word|
      if song.word_dict.keys.include?(word)
        k = Keyword.find_or_create_by(phrase: word)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end
end
