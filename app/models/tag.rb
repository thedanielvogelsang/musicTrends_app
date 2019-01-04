class Tag < ApplicationRecord
  validates_presence_of :context
  validates_presence_of :key_words
  has_many :keyword_taggings
  has_many :keywords, through: :keyword_taggings

  after_save :create_or_find_keywords

  def create_or_find_keywords
    key_words.each do |word|
      kw = Keyword.find_or_create_by(phrase: word.downcase)
      KeywordTagging.find_or_create_by(keyword_id: kw.id, tag_id: id)
    end
  end
end
