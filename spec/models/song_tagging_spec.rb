require 'rails_helper'

RSpec.describe SongTagging, type: :model do
  context "associations" do
    it{should belong_to(:song)}
    it{should belong_to(:tag)}
  end
  context "utility" do
    it "allows tags and songs to be associated" do
      song = Song.create(
        id: 1234,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Brittney Spears",
        annotation_ct: 3,
      )
      tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      expect(tag.songs.empty?).to be true
      SongTagging.create(song_id: song.id, tag_id: tag.id)
      expect(tag.songs.first).to eq(song)
    end
    it "can be added to a different tag" do
      song = Song.create(
        id: 1234,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Brittney Spears",
        annotation_ct: 3,
      )
      tag = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      tag2 = Tag.create(context: "High School", key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"])
      expect(tag.songs.count).to eq(0)
      expect(tag2.songs.count).to eq(0)
      SongTagging.create(song_id: song.id, tag_id: tag.id)
      SongTagging.create(song_id: song.id, tag_id: tag2.id)
      expect(tag.songs.count).to eq(1)
      expect(tag2.songs.count).to eq(1)
    end
  end
end
