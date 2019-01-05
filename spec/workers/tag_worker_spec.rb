require 'rails_helper'

RSpec.describe TagWorker, type: :model do
  describe "basic functionality" do
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
    it "#add_tag_to_song: assigns a song and tag together" do
      s_tag = TagWorker.add_tag_to_song(@tag.id, @song.id)
      expect(s_tag.class).to eq(SongTagging)
      expect(@tag.songs.first).to eq(@song)
      expect(@song.tags.first).to eq(@tag)
    end
  end
end
