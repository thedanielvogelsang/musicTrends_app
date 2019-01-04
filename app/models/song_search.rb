class SongSearch < ApplicationRecord
  belongs_to :song
  belongs_to :search

  before_create :add_initial_count

  private
    def add_initial_count
      self.count = 1
    end
end
