class Keyword < ApplicationRecord
  validates :phrase, presence: true, uniqueness: true
  has_many :keyword_taggings, dependent: :destroy
  has_many :tags, through: :keyword_taggings
  has_many :keyword_song_matches, dependent: :destroy
  has_many :keyword_search_matches, dependent: :destroy
  before_validation :downcase_phrase

  def downcase_phrase
    self.phrase = self.phrase.downcase if self.phrase
  end
end
