require 'rails_helper'

RSpec.describe SongWorker, type: :model do
  describe "basic functionality" do
    before(:each) do
      @song = Song.create(
        id: 1052,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Britney Spears",
        annotation_ct: 3,
      )
      @tag = Tag.create(
        context: "High School",
        key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"]
      )
    end
    it "#add_tag_to_song: assigns a song and tag together" do
      # s_tag = SongWorker.add_tag_to_song(@tag.id, @song.id)
      # expect(s_tag.class).to eq(SongTagging)
      # expect(@tag.songs.first).to eq(@song)
      # expect(@song.tags.first).to eq(@tag)
    end
    it "can return song_id as attr_reader" do
      VCR.use_cassette "/workers/britney_song_worker" do
        swork = SongWorker.new(@song.id)
        expect(swork.song_id).to eq(@song.id)
      end
    end
    it "initializes with an API call to find referent annotations" do
      VCR.use_cassette "/workers/britney_song_worker" do
        sworker = SongWorker.new(@song.id)
        expect(sworker.ref.class).to eq(Array)
        expect(sworker.ref.length).to eq(10)
      end
    end
  end
end
