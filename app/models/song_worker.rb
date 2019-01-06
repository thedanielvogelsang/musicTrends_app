class SongWorker
  include Words
  attr_reader :song_id, :refs

  def initialize(song_id)
    @song_id = song_id
    @refs = nil
  end

  def get_referents
    @refs = GeniusService.new.get_referents(song_id)
    return self
  end

  def self.confirm_referents_and_sync_song(song_id)
    new(song_id)
    if !confirm_referents
      get_referents_and_update_word_dict
    end
    sync_song
  end

  def self.update_with_refs_and_sync_song(song_id)
    pseudoSelf = new(song_id).get_referents
    sync_song
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

  def add_words_and_increment_count(new_words_hash)
    song = Song.find(song_id)
    word_count = song.word_dict
    new_words_hash.each do |word, ct|
      word_count[word] ? word_count[word] = word_count[word].to_i + ct : word_count[word] = ct
    end
    song.word_dict = word_count
    song.save
  end

  def add_word_to_dictionary_if_not_there(w)
    song = Song.find(song_id)
    word_dict = song.word_dict
    word_dict[w] ? word_dict : word_dict[w] = 1
    song.update(word_dict: word_dict)
  end

  #part one of calling a song
  def get_referents_and_update_word_dict
    get_referents
    update_or_create_word_dict_from_referents
  end

#called at each Song ping at songs_controller#show
  #should be called on all songs ?
  def sync_song
    save_highfreq_words_as_keywords
    save_title_and_artist_keywords
    find_and_match_keywords
  end

### FIRST SYNCHING -- SAVE REPEATED WORDS IN CORPUS AS KEYWORDs
  def save_highfreq_words_as_keywords
    freq_words_in_dict = Song.find(song_id)
                              .word_dict
                              .select{|k,v| v.to_i >= 3}
    freq_words_in_dict.keys.each do |frqword|
      if !CommonWords::WORDS.include?(frqword.downcase)
        k = Keyword.find_or_create_by(phrase: frqword.downcase)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end

### SECOND SYNCHING -- SAVE TITLE AND ARTIST NAME AS KEYWORDs
  def save_title_and_artist_keywords
    save_title_keywords
    save_artist_keywords
  end

  def save_title_keywords
    title = Song.find(song_id)
                .title
                .split(' ')
                .map{|w| w.downcase}
    title.each do |t|
      if !CommonWords::WORDS.include?(t)
        k = Keyword.find_or_create_by(phrase: t)
        KeywordSongMatch.search_and_add(k.id, song_id)
        add_word_to_dictionary_if_not_there(t)
      end
    end
  end

  def save_artist_keywords
    song = Song.find(song_id)
    artist_name = song.artist_name
                      .split(' ')
                      .map{|w| w.downcase}
    artist_name.each do |t|
        k = Keyword.find_or_create_by(phrase: t)
        KeywordSongMatch.search_and_add(k.id, song_id)
        add_word_to_dictionary_if_not_there(t)
    end
  end

  # not used in app, but in tests / for future use potentially
  def add_title_to_corpus
    title = Song.find(song_id)
                .title
                .split(' ')
                .map{|w| w.downcase}
    title.each do |t|
      if !CommonWords::WORDS.include?(t)
        add_word_to_dictionary_if_not_there(t)
      end
    end
  end

  def add_artist_to_corpus
    artist = Song.find(song_id)
                .artist_name
                .split(' ')
                .map{|w| w.downcase}
    artist.each do |t|
      if !CommonWords::WORDS.include?(t)
        add_word_to_dictionary_if_not_there(t)
      end
    end
  end

### THIRD SYNCHING -- SEARCH FOR PRE-EXISTING KEYWORDs
  #called at eah Song ping at songs_controller#show
  def find_and_match_keywords
    find_and_save_names
    find_and_save_products
    find_and_save_buzzwords
  end

  def find_and_save_products
    song = Song.find(song_id)
    #compared against downcased words
    Products::PRODUCTS.each do |word|
      if song.word_dict.keys.include?(word)
        k = Keyword.find_or_create_by(phrase: word)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end

  def find_and_save_buzzwords
    song = Song.find(song_id)
    #compared against downcased words
    Buzzwords::BUZZWORDS.each do |word|
      if song.word_dict.keys.include?(word)
        k = Keyword.find_or_create_by(phrase: word)
        KeywordSongMatch.search_and_add(k.id, song_id)
      end
    end
  end

  def find_and_save_names
    song = Song.find(song_id)
    song_dict = song.word_dict
    #Find words that follow the following potential-proper-noun regex pattern:
    prop_nouns = @refs.map do |ref|
      ref = ref[:annotations][0][:body][:dom][:children][0][:children]
      ref.join('').scan(/(([A-Z]{1}\w+\s*){2,})/).map{|mtch| mtch[0]}.flatten
    end
    prop_nouns + song.title.scan(/(([A-Z]{1}\w+\s*){2,})/).map{|mtch| mtch[0]}
    prop_nouns + song.artist_name.scan(/(([A-Z]{1}\w+\s*){2,})/).map{|mtch| mtch[0]}
    prop_nouns.flatten.each do |n|
      k = Keyword.find_or_create_by(phrase: n)
      KeywordSongMatch.search_and_add(k.id, song_id)
      add_word_to_dictionary_if_not_there(n)
    end
    return true
  end
end
