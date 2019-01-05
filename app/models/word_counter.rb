class WordCounter

  def initialize(record_type, id, ref)
    # can be Song, Search, or Lyrics (later) looking for word count
    @type = record_type
    @id = id
    @ref = ref
    which_counter
    clean_words
  end

  def count_words
    return_dict = {}
    @ref.split(' ').each do |word|
      return_dict[word] ? return_dict[word] += 1 : return_dict[word] = 1
    end
    return return_dict
  end

  private
    def which_counter
      case @type
      when "Song"
        @ref = clean_song_refs.join(' ')
      when "Search"
        @ref = clean_search_refs
      end
    end

    def clean_words
      @ref = @ref.gsub(/[^a-zA-Z0-9.\- ]/, "").strip
    end

    def clean_song_refs
      @ref.map do |annot|
        annot.class == String ? annot : nil
      end
    end
    def clean_search_refs
      byebug
    end
end
