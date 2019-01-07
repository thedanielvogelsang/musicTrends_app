require 'rails_helper'

RSpec.describe Song, type: :model do
  before(:each) do
    @song = Song.create(
      id: 1052,
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
    it {should have_many(:keyword_song_matches)}
    it {should have_many(:keywords)}
  end
  context "utility" do
    it "can call all attrs" do
      expect(@song.id).to eq(1052)
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
    describe "key_words" do
      it "can call top counted words from corpus" do
        VCR.use_cassette "/workers/britney_song_worker" do
          SongWorker.new(@song.id).get_referents_and_update_word_dict
          song = Song.find(@song.id)
          sorted_dict = song.word_dict.sort_by{|k, v| v}.reverse[0...10].to_h
          assert_equal(sorted_dict, song.key_words)
        end
      end
      it "can return different counts of words" do
        VCR.use_cassette "/workers/britney_song_worker" do
          SongWorker.new(@song.id).get_referents_and_update_word_dict
          song = Song.find(@song.id)
          assert_equal(5, song.key_words(5).count)
          assert_equal(15, song.key_words(15).count)
          assert_equal(25, song.key_words(25).count)
          assert_equal(100, song.key_words(100).count)
        end
      end
    end
  end
end
