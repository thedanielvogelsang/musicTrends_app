class SongSerializer < ActiveModel::Serializer
  attributes :id, :artist, :title, :important_keyword_matches,
             :playcount, :corpus_word_count, :keyword_matches,
             :key_words, :most_popular_words,
             :possible_tags, :current_tags,
             :possible_taggings

  def current_tags
    object.tags.pluck(:context)
  end
  def possible_taggings
    object.possible_taggings.count
  end
  def keyword_matches
    object.keyword_match_count
  end
  def important_keyword_matches
    object.key_matches
  end
  def corpus_word_count
    object.word_count
  end

end
