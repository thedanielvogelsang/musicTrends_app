class Song < ApplicationRecord
  validates_presence_of :id
  has_many :song_searches
  has_many :searches, through: :song_searches
end
