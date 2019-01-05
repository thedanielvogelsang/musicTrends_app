require 'rails_helper'
include Words

RSpec.describe SearchWorker, type: :model do
  describe "basic functionality" do
    before(:each) do
      @search = Search.create(
        search_type: "Song",
        text: "Won the grammys last year"
      )
    end
    it "SearchWorker initializes with existing search_id" do
      expect{ SearchWorker.new(0)}.to raise_error(ArgumentError)
      expect{ SearchWorker.new(@search.id)}.to_not raise_error
    end
  end
end
