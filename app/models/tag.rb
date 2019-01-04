class Tag < ApplicationRecord
  has_many :keyword_taggings
  has_many :keywords, through: :keyword_taggings
end
