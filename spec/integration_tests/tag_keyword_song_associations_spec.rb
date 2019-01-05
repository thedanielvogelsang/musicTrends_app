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
  end
  context "tags with keywords created separately" do
    before(:each) do
      @tag = Tag.create(
        context: "High School",
        key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"]
      )
    end
    describe "are only linked to songs via song_taggings" do
      it "can call songs" do
        SongTagging.create(song_id: @song.id, tag_id: @tag.id)
        expect(@tag.songs.first).to eq(@song)
      end
    end
    describe "and are NOT linked to songs without song_taggings" do
      it "can't call songs" do
        expect(@tag.songs.empty?).to be true
      end
    end
  end
  context "tags with keywords created in TagWorker" do
    before(:each) do
      @tag = Tag.create(
        context: "High School",
        key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"]
      )
      TagWorker.add_tag_to_song(@tag.id, @song.id)
    end
    describe "link to songs automatically" do
      it "and can call song" do
        expect(@tag.songs.count).to eq(1)
        expect(@tag.songs.first).to eq(@song)
      end
      it "and can be called indefinitely" do
        new_song = Song.create(
          id: 5678,
          title: "Tearin Up My Heart",
          artist_id: 24,
          artist_name: "N'Sync",
          annotation_ct: 12,
        )
        TagWorker.add_tag_to_song(@tag.id, new_song.id)
        expect(@tag.songs.count).to eq(2)
        expect(@tag.songs.first).to eq(@song)
        expect(@tag.songs.last).to eq(new_song)
      end
    end
    describe "create likely_taggings" do
      it "" do
        # expect(@tag).to be nil
      end
    end
  end
end
