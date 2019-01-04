require 'rails_helper'

RSpec.describe GeniusService do
  describe "Service Behaviors" do
    it "initializes with a connection to Genius" do
      api = GeniusService.new
      expect(api.conn.class).to eq(Faraday::Connection)
    end
  end
  context "utility" do
    it "#get_songs can get songs given a query" do
      VCR.use_cassette "/cassettes/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)
        assert_equal(20, api_return.length)
      end
    end
  end
end
