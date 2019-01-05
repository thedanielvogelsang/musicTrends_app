require 'rails_helper'

RSpec.describe KeywordSearchMatch, type: :model do
  context "associations" do
    it{should belong_to(:keyword)}
    it{should belong_to(:search)}
  end
  context "initializing counts" do
    before(:each) do
      @k = Keyword.create(phrase: "tomorrow")
      @s = Search.create(text: "what will the weather be tomorrow?")
    end
    it{should validate_presence_of(:count)}
    it "can circumnavigate this with class-level method" do
      expect(KeywordSearchMatch.count).to eq(0)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      expect(KeywordSearchMatch.count).to eq(1)
      expect(KeywordSearchMatch.first.count).to eq(1)
    end
    it "#search_and_add method increments match count" do
      expect(KeywordSearchMatch.count).to eq(0)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSearchMatch.search_and_add(@k.id, @s.id)
      expect(KeywordSearchMatch.count).to eq(1)
      expect(KeywordSearchMatch.first.count).to eq(5)
    end
  end
end
