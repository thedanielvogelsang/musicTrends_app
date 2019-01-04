require 'rails_helper'

RSpec.describe GeniusService do
  before(:each) do
    @song_id = 128399
  end
  describe "Service Behaviors" do
    it "initializes with a connection to Genius" do
      api = GeniusService.new
      expect(api.conn.class).to eq(Faraday::Connection)
    end
  end
  context "#get_songs utility" do
    it "#get_songs can get list of songs given a query" do
      VCR.use_cassette "/cassettes/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)
        assert_equal(20, api_return.length)
      end
    end
    it "#get_songs returns as array" do
      VCR.use_cassette "/cassettes/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)
        assert_equal(api_return.class, Array)
      end
    end
    it "#get_songs returns list of songs" do
      VCR.use_cassette "/cassettes/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)

        expect(/(\/songs)/.match(api_return.first[:api_path])).to be_truthy
        expect(/(\/artists)/.match(api_return.first[:api_path])).to be nil
      end
    end
  end
  context "#get_song_info utility" do
    it "#get_song_info returns single song given an id as Hash" do
      VCR.use_cassette "/cassettes/services/chicago_25or624" do
          api_return = GeniusService.new.get_song_info(@song_id)
          assert_equal(Hash, api_return.class)
          assert_equal("Chicago’s 1971 hit from their 1970’s second album – Chicago (sometimes retroactively called Chicago II).",
                        api_return[:description][:dom][:children][0][:children][0]
                      )
      end
    end
    it "#get_song_info returns nil for bad ids" do
      VCR.use_cassette "/cassettes/services/failed_song_id" do
          api_return = GeniusService.new.get_song_info(0)
          assert_nil(api_return)
      end
    end
  end
end
