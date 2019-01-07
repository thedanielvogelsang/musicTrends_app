class TagShowSerializer < ActiveModel::Serializer
  attributes :id, :context, :key_words,
              :possible_song_matches?,
              :keyword_translation,
              :song_matches,
              :keywords

  def keyword_translation
    object.keywords.pluck(:phrase)
  end
end
