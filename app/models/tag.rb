class Tag < ApplicationRecord
  validates_presence_of :context
  validates_presence_of :key_words
  has_many :keyword_taggings, dependent: :destroy
  has_many :keywords, through: :keyword_taggings
  has_many :song_taggings, dependent: :destroy
  has_many :songs, through: :song_taggings

  has_many :possible_taggings, dependent: :destroy

  after_save :create_or_find_keywords

  def create_or_find_keywords
    key_words.each do |word|
      kw = Keyword.find_or_create_by(phrase: word.downcase)
      KeywordTagging.find_or_create_by(keyword_id: kw.id, tag_id: id)
    end
  end

  def add_word(word)
    key_words << word
  end

  def possible_song_matches?
    Song.joins(:possible_taggings).where(:possible_taggings => {tag_id: id})
        .pluck(:id, :title, :artist_name)
  end

  def song_matches
    songs.pluck(:id, :title, :artist_name)
  end

  def update_keywords(keys)
    keys['key_words'].each do |new_word|
      add_word(new_word)
    end
    save
  end
end
