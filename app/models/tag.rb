class Tag < ApplicationRecord
  validates_presence_of :context
  validates_presence_of :key_words
  has_many :keyword_taggings
  has_many :keywords, through: :keyword_taggings
end
