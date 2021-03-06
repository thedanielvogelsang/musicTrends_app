class Song < ApplicationRecord
  validates_presence_of :id
  has_many :song_searches
  has_many :searches, through: :song_searches
  has_many :song_taggings
  has_many :tags, through: :song_taggings
  has_many :keyword_song_matches
  has_many :keywords, through: :keyword_song_matches

  has_many :possible_taggings

  def artist
    artist_name
  end

  def key_words(limit = 10)
    word_dict.sort_by{|k,v| v}.reverse[0...limit].to_h
  end

  def playcount
    song_searches.sum(:count)
  end

  def word_count
    word_dict.keys.count
  end

  def keyword_match_count
    KeywordSongMatch.where(song_id: id).count
  end

  def most_popular_words
    key_words(5)
  end

  def key_matches
    Keyword.joins(:keyword_song_matches).joins(:songs)
            .where(:songs => {id: id})
            .order("keyword_song_matches.count DESC")
            .pluck(:phrase).uniq[0..10]
  end

  def possible_tags
    Tag.joins(:possible_taggings).where(:possible_taggings => {song_id: id}).pluck(:id, :context)
  end

end
