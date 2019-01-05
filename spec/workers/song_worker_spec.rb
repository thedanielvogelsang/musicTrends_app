require 'rails_helper'
include Words

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
    it "requires only a single param to initialize" do
      expect{ SongWorker.new }.to raise_error(ArgumentError)
      expect{ SongWorker.new(1) }.to_not raise_error
      expect{ SongWorker.new(nil, 'longs string to strip apart') }.to_not raise_error
      # expect(SongWorker.new).to_not raise_error(ArgumentError)
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
        sw.update_or_create_word_dict_from_referents
        song = Song.find(@song.id)
        expect(hash).to_not eq(song.word_dict)
        expect(song.word_dict.empty?).to be false
        expect(song.word_dict.length).to eq(106)
      end
    end
    it "can do the same with an integrated method call" do
      VCR.use_cassette "/workers/britney_song_worker" do
        sw = SongWorker.new(@song.id).get_referents_and_update_word_dict
        song = Song.find(@song.id)
        expect(song.word_dict.empty?).to be false
        expect(song.word_dict.length).to eq(106)
      end
    end
    it "#save_highfreq_words_as_keywords saves key words as Keywords" do
      VCR.use_cassette "/workers/britney_song_worker" do
        expect(Keyword.count).to eq(0)
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict_from_referents
        sw.save_highfreq_words_as_keywords
        expect(Keyword.count > 0).to be true
      end
    end
    it "#save_highfreq_words_as_keywords also links song and keyword together" do
      VCR.use_cassette "/workers/britney_song_worker" do
        expect(@song.keywords.empty?).to be true
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict_from_referents
        sw.save_highfreq_words_as_keywords
        expect(@song.keywords.empty?).to be false
        expect(@song.keywords.count).to eq(5)
      end
    end
    it "#add_words_to_song adds a given word_hash param to song.word_dict" do
      VCR.use_cassette "/workers/britney_song_worker" do
        expect(@song.keywords.empty?).to be true
        sw = SongWorker.new(@song.id).get_referents
        sw.update_or_create_word_dict_from_referents
        sw.save_highfreq_words_as_keywords
        song = Song.find(@song.id)
        expect(song.keywords.empty?).to be false

        # assert this word doesnt already exist in corpus
        assert_nil(song.word_dict['science'])
        #find common word and increment it by 1
        word = song.key_words.first[0]
        value = song.key_words.first[1]
        new_words_hash = {'Britney' => '1', 'science' => 2, word => 1}
        sw.add_words_to_song(new_words_hash)
        song = Song.find(song.id)
        expect(song.word_dict['to']).to eq('10')
        expect(song.word_dict['Britney']).to eq('1')
        expect(song.word_dict['science']).to eq('2')
      end
    end
    it "completes order of operations" do
      VCR.use_cassette "/workers/britney_song_worker" do
        sw = SongWorker.new(@song.id)
        # no word_dict nor keyword association
        expect(@song.word_dict.keys.empty?).to be true
        expect(@song.keywords.empty?).to be true
        sw.get_referents_and_update_word_dict
        # Songworker.get_referents_and_update_word_dict updates word_dict
        song = Song.find(@song.id)
        expect(song.word_dict.keys.empty?).to be false
        # but doesnt create associations
        expect(song.keywords.empty?).to be true

        # run #save_highfreq_words_as_keywords
        sw.save_highfreq_words_as_keywords
        song = Song.find(@song.id)
          ct = song.keywords.count
          key_ct = Keyword.count
          expect(ct > 0).to be true
        # creates new keywordSongMatches and Keywords given buzzwords
        sw.find_and_save_buzzwords
          if song.keywords.count > ct
            expect(Keyword.count > key_ct).to be true
          end
      end
    end
  end
  describe "advanced sync" do
    before(:each) do
      @song = Song.create(
        id: 85260,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Britney Spears",
        annotation_ct: 3,
      )
    end
    it "#find_and_save_buzzwords
              associates keywords given a list of buzzwords" do
      VCR.use_cassette "/workers/queen_buzzwords" do
        words = Words::Buzzwords::BUZZWORDS
        expect(words.include?("sexual")).to be true
        sw = SongWorker.new(@song.id)
        # no word_dict nor keyword association
        expect(@song.word_dict.keys.empty?).to be true
        expect(@song.keywords.empty?).to be true
        sw.get_referents_and_update_word_dict
        # Songworker.get_referents_and_update_word_dict updates word_dict
        song = Song.find(@song.id)
        expect(song.word_dict.keys.empty?).to be false
        # word `sexual` is in corpus but not > 3 times
        expect(song.key_words.keys.include?("sexual")).to be false
        expect(song.word_dict.keys.include?("sexual")).to be true
        assert_equal(song.word_dict["sexual"], '2')
        # but doesnt create associations
        expect(song.keywords.empty?).to be true

        # run #save_highfreq_words_as_keywords
        key_ct = Keyword.count
        sw.save_highfreq_words_as_keywords
          song = Song.find(@song.id)
          #keywords created here do not include "Sean"
          ct = song.keywords.count
          expect(ct > 0).to be true
          expect(Keyword.count > key_ct).to be true
          key_ct = Keyword.count
          expect(song.keywords.pluck(:phrase).include?("sexual")).to be false
        # creates new keywordSongMatches
        sw.find_and_save_buzzwords
          if song.keywords.count > ct
            expect(song.keywords.pluck(:phrase).include?("sexual")).to be true
            expect(Keyword.count > key_ct).to be true
          end
      end
    end
    it "#find_and_save_products (w/ add_title_to_corpus)
              associates keywords given a list of products" do
      VCR.use_cassette "/workers/ipod_products_proof" do
        # Eric Bellinger's `IPod on Shuffle`
        song = Song.create(
          id: 2035289,
          title: "IPod on Shuffle",
          artist_id: 1202,
          artist_name: "Eric Bellinger",
          annotation_ct: 0,
        )
        words = Words::Products::PRODUCTS
        expect(words.include?("ipod")).to be true
        sw = SongWorker.new(song.id)
        # no word_dict nor keyword association
        expect(song.word_dict.keys.empty?).to be true
        expect(song.keywords.empty?).to be true
        sw.get_referents_and_update_word_dict

        # Songworker.get_referents_and_update_word_dict and
              # add_title_to_corpus
              # updates word_dict
        sw.add_title_to_corpus
        song = Song.find(song.id)
        expect(song.word_dict.keys.empty?).to be false
        expect(song.word_dict.keys.include?('ipod')).to be true
        # word `ipod` is in corpus but not > 3 times
        # but doesnt create associations
        expect(song.keywords.empty?).to be true
        # until save_title_and_artist is called:
        # saves IPod as part of songs word_dict
        key_ct = Keyword.count
        sw.save_highfreq_words_as_keywords
          song = Song.find(song.id)
          #keywords created here include iPod which will then be used later...
          ct = song.keywords.count
          expect(Keyword.count > key_ct).to be true
          expect(song.keywords.pluck(:phrase).include?("ipod")).to be false
        # find_and_save_products
        # creates new keywordSongMatches
        sw.find_and_save_products
          if song.keywords.count > ct
            expect(song.keywords.pluck(:phrase).include?("ipod")).to be true
            expect(Keyword.count > key_ct).to be true
          end
      end
    end
    it "#save_title_and_artist_keywords updates keywords too" do
      VCR.use_cassette "/workers/ipod_products_proof" do
        # Eric Bellinger's `IPod on Shuffle`
        song = Song.create(
          id: 2035289,
          title: "IPod on Shuffle",
          artist_id: 1202,
          artist_name: "Eric Bellinger",
          annotation_ct: 0,
        )
        words = Words::Products::PRODUCTS
        expect(words.include?("ipod")).to be true
        sw = SongWorker.new(song.id)
        # no word_dict nor keyword association
        expect(song.word_dict.keys.empty?).to be true
        expect(song.keywords.empty?).to be true
        sw.get_referents_and_update_word_dict

        # Songworker.get_referents_and_update_word_dict and
              # save_title_and_artist_keywords
              # updates word_dict
        song = Song.find(song.id)
        expect(song.word_dict.keys.empty?).to be false
        expect(song.word_dict.keys.include?('ipod')).to be false
        # word `ipod` is in corpus but not > 3 times
        # but doesnt create associations
        expect(song.keywords.empty?).to be true
        # until save_title_and_artist is called:
        # saves IPod as part of songs word_dict
        sw.save_title_and_artist_keywords

        song = Song.find(song.id)
        expect(song.word_dict.keys.include?('ipod')).to be true
        assert_equal(song.word_dict["ipod"], '1')
        expect(song.keywords.empty?).to be false
        expect(song.keywords.count).to eq(4)
        # run #save_highfreq_words_as_keywords
        key_ct = Keyword.count
        expect(key_ct).to eq(4)
        sw.save_highfreq_words_as_keywords
          song = Song.find(song.id)
          #keywords created here do not include "Sean"
          ct = song.keywords.count
          expect(Keyword.count > key_ct).to be true
          expect(song.keywords.pluck(:phrase).include?("ipod")).to be true
        # find_and_save_products
        # creates new keywordSongMatches
        sw.find_and_save_products
          if song.keywords.count > ct
            expect(song.keywords.pluck(:phrase).include?("ipod")).to be true
            expect(Keyword.count > key_ct).to be true
          end
      end
    end
  end
end
