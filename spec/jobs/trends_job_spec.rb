require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "TrendsJob", :type => :job do
  Sidekiq::Testing.inline! do
    context "initializing" do
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
      describe "performing a song trend update" do
        it "performs job with accurate params" do
          VCR.use_cassette("workers/integration_tests", :record => :new_episodes) do
            sw = SongWorker.confirm_referents_and_sync_song(@song.id)
            return_trends = sw.find_trends
            TrendsJob.perform_async('Song', return_trends)
            assert_equal(1, TrendsJob.jobs.size)
            expect{Sidekiq::Worker.drain_all}.to_not raise_error
          end
        end
      end
    end
  end
end
