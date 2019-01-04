require 'rails_helper'

RSpec.describe GeniusService do
  describe "Service Behaviors" do
    it "initializes with a connection to Genius" do
      api = GeniusService.new
      expect(api.conn.class).to eq(Faraday::Connection)
    end
  end
  context "utility" do
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
end
