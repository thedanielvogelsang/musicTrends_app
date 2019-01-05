class Keyword < ApplicationRecord
  validates_presence_of :phrase, uniqueness: true, :case_sensitive => false
  has_many :keyword_taggings
  has_many :tags, through: :keyword_taggings

  before_save :downcase_phrase

  def downcase_phrase
    self.phrase = self.phrase.downcase
  end
end
