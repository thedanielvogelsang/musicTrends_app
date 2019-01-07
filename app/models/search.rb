class Search < ApplicationRecord
  validates :text, presence: true, uniqueness: true
  enum search_type: ["Song", "Lyric"]
  has_many :song_searches
  has_many :songs, through: :song_searches

  before_create :add_initial_count

  def song_counts
    sct = {}
    self.song_searches.each{|ss| sct[ss.count] = [ss.song_id, ss.song.title]}
    return sct
  end

  private
    def add_initial_count
      self.count = 1
    end
end
