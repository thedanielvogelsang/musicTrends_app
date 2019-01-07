require 'rails_helper'

RSpec.describe TrendService do
  before(:each) do
  end
  describe "intialization" do
    it "requires type and param to generate log" do
      expect{TrendService.new}.to raise_error(ArgumentError)
      expect{TrendService.new("Song", {})}.to_not raise_error
    end
    it "initializes with a connection" do
      aws = TrendService.new("Song", {})
      expect(aws.conn.class).to eq(Aws::S3::Client)
    end
  end
  describe "utility" do
    it "can put an object to aws console" do
      
    end
  end
end
