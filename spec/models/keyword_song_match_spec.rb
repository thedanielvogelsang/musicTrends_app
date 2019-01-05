require 'rails_helper'

RSpec.describe KeywordSongMatch, type: :model do
  context "associations" do
    it{should belong_to(:keyword)}
    it{should belong_to(:song)}
  end
  context "initializing counts" do
    before(:each) do
      @k = Keyword.create(phrase: "tomorrow")
      @s = Song.create(
          id: 1052,
          title: "Song Title",
          artist_id: 12,
          artist_name: "Britney Spears",
          annotation_ct: 3,
        )
    end
    it{should validate_presence_of(:count)}
    it "can circumnavigate this with class-level method" do
      expect(KeywordSongMatch.count).to eq(0)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      expect(KeywordSongMatch.count).to eq(1)
      expect(KeywordSongMatch.first.count).to eq(1)
    end
    it "#search_and_add method increments match count" do
      expect(KeywordSongMatch.count).to eq(0)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      kws = KeywordSongMatch.search_and_add(@k.id, @s.id)
      expect(KeywordSongMatch.count).to eq(1)
      expect(KeywordSongMatch.first.count).to eq(5)
    end
  end
end
