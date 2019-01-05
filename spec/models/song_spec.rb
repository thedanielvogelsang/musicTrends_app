require 'rails_helper'

RSpec.describe Song, type: :model do
  before(:each) do
    @song = Song.create(
      id: 1234,
      title: "Song Title",
      artist_id: 12,
      artist_name: "Brittney Spears",
      annotation_ct: 3,
    )
  end
  context "validations" do
    it {should validate_presence_of(:id)}
  end
  context "associations" do
    it {should have_many(:song_searches)}
    it {should have_many(:searches)}
  end
  context "utility" do
    it "can call all attrs" do
      expect(@song.id).to eq(1234)
      expect(@song.artist_id).to eq(12)
      expect(@song.artist_name).to eq("Brittney Spears")
      expect(@song.annotation_ct).to eq(3)
    end
    it "can utilize and store data in its word dictionary" do
      expect(@song.update(word_dict: {'key' => 'value'})).to be true
      expect(@song.word_dict['key']).to eq('value')
    end
    it "word dictionary responds to string not symbol" do
      expect(@song.update(word_dict: {'key' => 'value'})).to be true
      assert_nil(@song.word_dict[:key])
      expect(@song.word_dict['key']).to eq('value')
    end
    it "can call artist and get artist name" do
      expect(@song.artist).to eq(@song.artist_name)
    end
  end
  context "word_dict usage" do

  end
end
