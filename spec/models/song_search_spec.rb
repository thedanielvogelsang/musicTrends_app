require 'rails_helper'

RSpec.describe SongSearch, type: :model do
  before(:each) do
    @song = Song.create(
      id: 1234,
      title: "Oops I Did It Again",
      artist_id: 12,
      artist_name: "Brittney Spears",
      annotation_ct: 3,
    )
    @search = Search.create(
      search_type: "Song",
      text: "Whats the name of that one song that begins with 'Oops'"
    )
    @songsearch = SongSearch.create(song_id: @song.id, search_id: @search.id)
  end
  context "utility" do
    it "initializes with count = 1" do
      expect(@songsearch.count).to eq(1)
    end
    it "allows songs and searches to be associated" do
      expect(@song.searches.first).to eq(@search)
      expect(@search.songs.first).to eq(@song)
    end
  end
end
