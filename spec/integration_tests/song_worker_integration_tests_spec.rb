require 'rails_helper'

RSpec.describe SongWorker do
  context "integration tests" do
    describe "with pre-existing song without pre-existing referents" do
      before(:each) do
        @song = Song.create(
          id: 1052,
          title: "Song Title",
          artist_id: 12,
          artist_name: "Britney Spears",
          annotation_ct: 3,
          word_dict: {"Previous Keyword" => 1, "racetrack" => 2},
        )
      end
      it "#can create keywords from products, buzzwords,
                          names, high_frequency words, artist/title;
              word_dict and referents ALL with one command" do
        VCR.use_cassette "workers/integration_tests" do
          song = Song.first
          expect(Song.count).to eq(1)
          expect(song.refs_found?).to be false

          proper_name = @song.artist_name
          expect(song.word_dict.keys.include?(proper_name)).to be false
          expect(Keyword.where(phrase: "britney spears").count).to eq(0)
          expect(song.word_dict.keys.include?("britney")).to be false
          expect(Keyword.where(phrase: "britney").count).to eq(0)
          expect(song.word_dict.keys.include?("spears")).to be false
          expect(Keyword.where(phrase: "spears").count).to eq(0)
          expect(song.word_dict.keys.include?("racetrack")).to be true
          expect(song.word_dict.keys.include?("title")).to be false

          #SongWorker song must inherit a song that has referents to function
          # expect{ SongWorker.confirm_referents_and_sync_song(song.id)}.to raise_error(ArgumentError)
          # song.update(updated_at: DateTime.now - (60*60*48))
          sworker = SongWorker.confirm_referents_and_sync_song(song.id)
          song = Song.find(song.id)
          expect(song.word_dict.keys.include?(proper_name)).to be true
          expect(Keyword.where(phrase: "britney spears").count).to eq(1)

          #proves #save_artist_keywords ran
          expect(song.word_dict.keys.include?("britney")).to be true
          expect(Keyword.where(phrase: "britney").count).to eq(1)
          expect(song.word_dict.keys.include?("spears")).to be true
          expect(Keyword.where(phrase: "spears").count).to eq(1)

          # original words still in dict (each time through will not delete old words)
          expect(song.word_dict.keys.include?("Previous Keyword")).to be true
          expect(song.word_dict.keys.include?("racetrack")).to be true

          # proves #save_title_words
          expect(song.word_dict.keys.include?("title")).to be true
          song = Song.first
          expect(Song.count).to eq(1)
          expect(song.refs_found?).to be true
        end
      end
      it "#after creating keywords, it can find trends" do
        VCR.use_cassette "workers/integration_tests" do
          song = Song.first
          sworker = SongWorker.confirm_referents_and_sync_song(song.id)
          return_trends = sworker.find_trends
          expect(return_trends[:type]).to eq("Song")
          expect(return_trends[:id]).to eq(1052)
          expect(return_trends[:playcount]).to eq(0)
          expect(return_trends[:corpus_word_count]).to eq(124)
          expect(return_trends[:popular_words_in_corpus].keys).to eq(['to', 'sean', 'in', 'of', 'a'])
          expect(return_trends[:keyword_matches]).to eq(21) | eq(22)
          expect(return_trends[:important_keyword_matches]).to eq(["back", "flow", "sean", "song", "title", "britney", "spears", "big sean ", "supa dupa flow", "big"])
        end
      end
      it "#find_trends also includes possible tags" do
        VCR.use_cassette "workers/integration_tests" do
          tag = Tag.create(context: "1990s", key_words: ["Britney Spears", "song", "back", "Justin", "skateboards"])
          song = Song.first
          #song word_dict created and saved here
          sworker = SongWorker.confirm_referents_and_sync_song(song.id)
          # worker returns trend data for console logging
          return_trends = sworker.find_trends
          expect(return_trends[:type]).to eq("Song")
          expect(return_trends[:id]).to eq(1052)
          expect(return_trends[:possible_taggings]).to eq(0)

          tworker = TagWorker.new(tag.id)
          songs = tworker.match_likely_songs
          expect(songs.first).to eq(Song.find(song.id))
          return_trends = sworker.find_trends
          expect(return_trends[:type]).to eq("Song")
          expect(return_trends[:id]).to eq(1052)
          expect(return_trends[:possible_taggings]).to eq(1)
          expect(return_trends[:possible_tags].count).to eq(1)
          expect(return_trends[:possible_tags].first[0]).to eq(tag.id)
          expect(return_trends[:possible_tags].first[1]).to eq("1990s")
        end
      end
    end
  end
end
