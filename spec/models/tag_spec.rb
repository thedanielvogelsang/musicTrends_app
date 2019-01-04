require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:each) do
    @tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
  end
  context "validations" do
    it{should validate_presence_of(:context)}
    it{should validate_presence_of(:key_words)}
  end
  context "associations" do
    it{should have_many(:keyword_taggings)}
    it{should have_many(:keywords)}
  end
  context "keywords" do
    it "created via tagging are downcased" do
      #tag creation automatically creates 6 Keyword records
      expect(@tag.keywords.count).to eq(6)
      expect(Keyword.count).to eq(6)
      #none of these keywords will have capitals
      assert_nil(/[A-Z]/.match(Keyword.pluck(:phrase).join('')))
    end
    it "added via Keyword.create() are NOT downcased" do
      #tag creation automatically creates 6 Keyword records and associates tag with each
      expect(@tag.keywords.count).to eq(6)
      expect(@tag.keyword_taggings.count).to eq(6)
      expect(Keyword.count).to eq(6)
      #none of these keywords will be capitalized
      assert_nil(/[A-Z]/.match(Keyword.pluck(:phrase).join('')))

      #create a keyword and associate it to a Tag...
      keyword = Keyword.create(phrase: "Hormones")
      KeywordTagging.create(keyword_id: keyword.id, tag_id: @tag.id)
      expect(@tag.keywords.count).to eq(7)
      expect(Keyword.count).to eq(7)
      #and this keyword however (created outside Tag) allows capitalization
      match = /[A-Z]/.match(Keyword.pluck(:phrase).join(''))
      expect(match.length).to eq(1)
      expect(match[0]).to eq("H")
    end
  end
  context "key_words" do
    it "added upon creation are NOT downcased" do
      expect(@tag.key_words.count).to eq(6)
      assert_equal(@tag.key_words.join('').scan(/[A-Z]/).length, 1)
      assert_equal(@tag.keywords.pluck(:phrase).join('').scan(/[A-Z]/).length, 0)
    end
    it "added later are added to Keywords (and NOT downcased)" do
      tag = @tag
      expect(tag.keywords.count).to eq(6)
      tag.key_words << "Math"
      tag.save
      expect(tag.key_words.count).to eq(7)
      expect(tag.keywords.count).to eq(7)
      #"Math" keyword is downcased too added this way (through Tag save)
      assert_equal(tag.keywords.pluck(:phrase).join('').scan(/[A-Z]/).length, 0)
    end
    it 'can be single or multiple words' do
      tag = @tag
      expect(tag.keywords.count).to eq(6)
      tag.key_words << "Arts & Crafts"
      tag.save
      expect(tag.key_words.count).to eq(7)
      expect(tag.keywords.count).to eq(7)
      expect(Keyword.last.phrase).to eq("arts & crafts")
    end
  end
  context "key_words vs keywords" do
    it "key_words are not downcased, only keywords resulting from Tag save" do
      tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      expect(tag.key_words.count).to eq(6)
      assert_equal(tag.key_words.join('').scan(/[A-Z]/).length, 1)
      assert_equal(tag.keywords.pluck(:phrase).join('').scan(/[A-Z]/).length, 0)
    end
    it "key_words added later vs keywords" do
      keyword = Keyword.create(phrase: "Hormones")

      expect(@tag.keywords.count).to eq(6)
      KeywordTagging.create(keyword_id: keyword.id, tag_id: @tag.id)
      expect(@tag.keywords.count).to eq(7)
    end
  end
end
