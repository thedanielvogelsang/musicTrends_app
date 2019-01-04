class Keyword < ApplicationRecord
  validates_presence_of :phrase, uniqueness: true
  has_many :keyword_taggings
  has_many :tags, through: :keyword_taggings
end
