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
    end
    it "can return song_id as attr_reader" do
        swork = SongWorker.new(@song.id)
        expect(swork.song_id).to eq(@song.id)
    end
    it "can return ref_list as attr_reader" do
      VCR.use_cassette "/workers/britney_song_worker" do
        swork = SongWorker.new(@song.id)
        swork.get_referents
        expect(swork.refs).to be_truthy
        expect(swork.refs.class).to eq(Array)
      end
    end
    it "initializes without an API call to find referent annotations" do
      VCR.use_cassette "/workers/britney_song_worker" do
        sworker = SongWorker.new(@song.id)
        assert_nil(sworker.refs)
        sworker.get_referents
        expect(sworker.refs).to be_truthy
        expect(sworker.refs.class).to eq(Array)
        expect(sworker.refs.length).to eq(10)
      end
    end
  end
  describe "worker functionality / record manipulation" do
    before(:each) do
      @song = Song.create(
        id: 1052,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Britney Spears",
        annotation_ct: 3,
      )
    end
    it "can update a songs hash with comprehensive list of words" do
      VCR.use_cassette "/workers/britney_song_worker" do
        hash = @song.word_dict
        expect(hash.empty?).to be true
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict
        song = Song.find(@song.id)
        expect(hash).to_not eq(song.word_dict)
        expect(song.word_dict.empty?).to be false
        expect(song.word_dict.length).to eq(117)
      end
    end
    it "can do the same with an integrated method call" do
      VCR.use_cassette "/workers/britney_song_worker" do
        sw = SongWorker.new(@song.id).get_referents_and_update_word_dict
        song = Song.find(@song.id)
        expect(song.word_dict.empty?).to be false
        expect(song.word_dict.length).to eq(117)
      end
    end
    it "#save_highfreq_words_as_keywords saves key words as Keywords" do
      VCR.use_cassette "/workers/britney_song_worker" do
        expect(Keyword.count).to eq(0)
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict
        sw.save_highfreq_words_as_keywords
        expect(Keyword.count > 0).to be true
      end
    end
    it "#save_highfreq_words_as_keywords also links song and keyword together" do
      VCR.use_cassette "/workers/britney_song_worker" do
        expect(@song.keywords.empty?).to be true
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict
        sw.save_highfreq_words_as_keywords
        expect(@song.keywords.empty?).to be false
      end
    end
  end
end
