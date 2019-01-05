class Keyword < ApplicationRecord
  validates :phrase, presence: true, uniqueness: true
  has_many :keyword_taggings
  has_many :tags, through: :keyword_taggings

  before_validation :downcase_phrase

  def downcase_phrase
    self.phrase = self.phrase.downcase if self.phrase
  end
end
