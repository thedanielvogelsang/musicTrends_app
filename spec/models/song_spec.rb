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
    it "can call artist and get artist name" do
      expect(@song.artist).to eq(@song.artist_name)
    end
  end
end
