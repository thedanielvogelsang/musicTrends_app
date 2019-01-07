require 'rails_helper'

RSpec.describe TrendsService do
  before(:each) do
  end
  describe "intialization" do
    it "requires type and param to generate log" do
      expect{TrendsService.new}.to raise_error(ArgumentError)
      expect{TrendService.new("Song", {})}.to_not raise_error
    end
    it "initializes with a connection" do
      aws = TrendsService.new("Song", {})
      expect(aws.conn.class?).to eq(AWS::Client::Connection)
    end
  end

end
