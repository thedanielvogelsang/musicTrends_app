require 'rails_helper'
require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

RSpec.describe "MasterSearchJob", :type => :job do
  Sidekiq::Testing.fake! do
    context "initializing" do
      it "requires accurate song and search params" do
        MasterSearchJob.perform_async('art1', 'art2')
        assert_equal(1, MasterSearchJob.jobs.size)
        expect{Sidekiq::Worker.drain_all}.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "can initialize with proper params" do
        VCR.use_cassette("master/integrations_test_random", :allow_playback_repeats => true, :record => :new_episodes) do
          song_params = {id: 1052, title: "Song Title", artist_id: 12, artist_name: "Britney Spears", annotation_ct: 3}
          search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
          MasterSearchJob.perform_async(song_params, search_params)
          expect{Sidekiq::Worker.drain_all}.to_not raise_error
        end
      end
      it "cannot create song nor search with bad params" do
        expect(Song.count).to eq(0)
        expect(Search.count).to eq(0)
        MasterSearchJob.perform_async('art1', 'art2')
        assert_equal(1, MasterSearchJob.jobs.size)
        expect{Sidekiq::Worker.drain_all}.to raise_error(ActiveRecord::RecordNotFound)
        expect(Song.count).to eq(0)
        expect(Search.count).to eq(0)
      end
      it "creates a new Song and Search given valid params" do
        VCR.use_cassette("master/integrations_test_random", :allow_playback_repeats => true, :record => :new_episodes) do
          expect(Song.count).to eq(0)
          expect(Search.count).to eq(0)
          song_params = {id: 1052, title: "Song Title", artist_id: 12, artist_name: "Britney Spears", annotation_ct: 3}
          search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
          MasterSearchJob.perform_async(song_params, search_params)
          expect{Sidekiq::Worker.drain_all}.to_not raise_error
          expect(Song.count).to eq(1)
          expect(Search.count).to eq(1)
        end
      end
      it "triggers an association between song and search" do
        VCR.use_cassette("master/integrations_test_random", :allow_playback_repeats => true) do
          song = Song.create(id: 1052)
          search = Search.create(search_type: "Song", text: "Whats the name of the band that plays 'Whatever'?")
          expect(song.searches.count).to eq(0)
          expect(search.songs.count).to eq(0)
          song_params = {id: 1052, title: "Song Title", artist_id: 12, artist_name: "Britney Spears", annotation_ct: 3}
          search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
          MasterSearchJob.perform_async(song_params, search_params)
          Sidekiq::Worker.drain_all
          expect(Song.count).to eq(1)
          expect(Search.count).to eq(1)
          expect(Song.first.searches.count).to eq(1)
          expect(Song.first.searches.first).to eq(Search.first)
        end
      end
      it "will update song-search :count attr if replayed" do
        VCR.use_cassette("master/integrations_test_random", :allow_playback_repeats => true) do
          song_params = {id: 1052, title: "Song Title", artist_id: 12, artist_name: "Britney Spears", annotation_ct: 3}
          search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
          MasterSearchJob.perform_async(song_params, search_params)
          MasterSearchJob.perform_async(song_params, search_params)
          expect(MasterSearchJob.jobs.size).to eq(2)
          Sidekiq::Worker.drain_all
          expect(Song.count).to eq(1)
          expect(Search.count).to eq(1)
          expect(SongSearch.count).to eq(1)
          expect(SongSearch.first.count).to eq(2)
        end
      end
    end
  end
end
