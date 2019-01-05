class Song < ApplicationRecord
  validates_presence_of :id
  has_many :song_searches
  has_many :searches, through: :song_searches
  has_many :song_taggings
  has_many :tags, through: :song_taggings
  has_many :keyword_song_matches
  has_many :keywords, through: :keyword_song_matches

  def artist
    artist_name
  end

end
