require 'rails_helper'

RSpec.describe "Tag Keyword Song Integration Tests" do
  before(:each) do
    @song = Song.create(
      id: 1234,
      title: "Song Title",
      artist_id: 12,
      artist_name: "Brittney Spears",
      annotation_ct: 3,
    )
    @tag = Tag.create(
      context: "High School",
      key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"]
    )
  end
  describe "tags with keywords that" do
    context "are linked via keyword_song_matches" do
      it "can call songs" do
        expect(@tag.songs.first).to eq(@song)
      end
    end
    context " are linked to songs via keyword_song_matches" do
      it "can't call songs" do
        expect(@tag.songs.empty?).to be true
      end
    end
  end
end
