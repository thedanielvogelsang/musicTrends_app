class Search < ApplicationRecord
  validates :text, presence: true, uniqueness: true
  enum search_type: ["Song", "Lyric"]
  has_many :song_searches
  has_many :songs, through: :song_searches

  before_create :add_initial_count

  private
    def add_initial_count
      self.count = 1
    end
end
