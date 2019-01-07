require 'rails_helper'

RSpec.describe KeywordTagging, type: :model do
  context "associations" do
    it{should belong_to(:keyword)}
    it{should belong_to(:tag)}
  end
  context "utility" do
    it "allows tags and keywords to be associated" do
      keyword = Keyword.create(phrase: "Hormones")
      tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      KeywordTagging.create(keyword_id: keyword.id, tag_id: tag.id)
      expect(tag.keywords.pluck(:phrase).include?('hormones')).to be true
    end
    it "can be added to a tag" do
      keyword = Keyword.create(phrase: "Hormones")
      tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      expect(tag.keywords.count).to eq(6)
      KeywordTagging.create(keyword_id: keyword.id, tag_id: tag.id)
      expect(tag.keywords.count).to eq(7)
    end
  end
end
