require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "MasterSearchJob", :type => :job do
  Sidekiq::Testing.inline! do
    context "initializing" do
      it "requires song and search params" do
        MasterSearchJob.perform_async('art1', 'art2')
        assert_equal(1, MasterSearchJob.jobs.size)
        expect{Sidekiq::Worker.drain_all}.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "can initialize with proper params" do
        song_params = {id: 28660, artist_id: 1230586, artist_name: "Artist 1", title: "Whatever", annotation_ct: 0}
        search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
        MasterSearchJob.perform_async(song_params, search_params)
        expect{Sidekiq::Worker.drain_all}.to_not raise_error
      end
      it "creates a new Song and Search" do
        expect(Song.count).to eq(0)
        expect(Search.count).to eq(0)
        song_params = {id: 28660, artist_id: 1230586, artist_name: "Artist 1", title: "Whatever", annotation_ct: 0}
        search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
        MasterSearchJob.perform_async(song_params, search_params)
        expect{Sidekiq::Worker.drain_all}.to_not raise_error
        expect(Song.count).to eq(1)
        expect(Search.count).to eq(1)
      end
      it "triggers an association between song and search" do
        # song = Song.create(id: 28660)
        # search = Search.create(search_type: "Song", text: "Whats the name of the band that plays 'Whatever'?")
        # expect(song.searches.count).to eq(0)
        # expect(search.songs.count).to eq(0)
        song_params = {id: 28660, artist_id: 1230586, artist_name: "Artist 1", title: "Whatever", annotation_ct: 0}
        search_params = {text: "Whats the name of the band that plays 'Whatever'?", search_type: "Song"}
        MasterSearchJob.perform_async(song_params, search_params)
        Sidekiq::Worker.drain_all
        expect(Song.count).to eq(1)
        expect(Search.count).to eq(1)
        expect(Song.first.searches.count).to eq(1)
        expect(Song.first.searches.first).to eq(Search.first)
      end
    end
  end
end
