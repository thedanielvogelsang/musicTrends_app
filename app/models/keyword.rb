class Keyword < ApplicationRecord
  has_many :keyword_taggings
  has_many :tags, through: :keyword_taggings
end
