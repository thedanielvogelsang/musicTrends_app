require 'rails_helper'

RSpec.describe Search, type: :model do
  before(:each) do
    @search = Search.create(
      search_type: "Song",
      text: "Whats the name of that one song that begins with..."
    )
  end
  context "validations" do
    it {should validate_presence_of(:text)}
    it {should validate_uniqueness_of(:text)}
  end
  context "associations" do
    it {should have_many(:song_searches)}
    it {should have_many(:songs)}
  end
  context "utility" do
    it "can call all attrs" do
      expect(@search.id).to be_truthy
      expect(@search.text).to eq("Whats the name of that one song that begins with...")
      expect(@search.search_type).to eq("Song")
      expect(@search.search_type?).to eq(true)
    end
    it "defaults to count = 1 upon creation" do
      expect(@search.count).to eq(1)
    end
    it "Must be a different text name" do
      old_search = Search.new(text: "Whats the name of that one song that begins with...")
      new_search = Search.new(text: "Something else", search_type: 1)
      expect(old_search.save).to be false
      expect(new_search.save).to be true
      expect(new_search.search_type).to eq("Lyric")
      expect(new_search.count).to eq(1)
    end
    it "defaults with Song as enumerator if not present" do
      new_search = Search.create(text: "Something else")
      expect(new_search.id).to be_truthy
      expect(new_search.text).to eq("Something else")
      expect(new_search.search_type).to eq("Song")
      expect(new_search.search_type?).to eq(true)
      expect(new_search.count).to eq(1)
    end
  end
end
