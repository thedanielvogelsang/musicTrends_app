class SearchWorker
  include Words
  attr_reader :search_id, :ref

  def initialize(search_id)
    @search_id = Search.find(search_id).id
    rescue ActiveRecord::RecordNotFound => e
        raise ArgumentError, 'Argument is not numeric and/or Record cannot be found'
    @ref = nil
  end

  def clean_and_separate_words
    @ref = Search.find(search_id).text
    clean_words
  end

  def clean_words
    @ref = @ref.gsub(/[^a-zA-Z0-9 ]/, "").split(' ').map{|w| w.downcase}.join(' ').strip
  end

  def create_keywords
    clean_and_separate_words
    @ref.split(' ').each do |word|
      unless CommonWords::WORDS.include?(word)
        k = Keyword.find_or_create_by(phrase: word)
        KeywordSearchMatch.search_and_add(k.id, search_id)
      end
    end
  end

  def find_trends
    search = Search.find(search_id)
    return {
      type: "Search",
      id: search_id,
      text: search.text,
      song_matches: search.songs.count
    }
  end
end
