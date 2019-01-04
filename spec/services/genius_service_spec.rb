require 'rails_helper'

RSpec.describe GeniusService do
  describe "Service Behaviors" do
    it "initializes with a connection to Genius" do
      api = GeniusService.new
      expect(api.conn.class).to eq(Faraday::Connection)
    end
  end
  context "utility" do
    it "can get songs given a query" do
      query = "Go tell it on the mountain"
      api_return = GeniusService.new.get_songs(query)
      byebug
    end
  end
end
