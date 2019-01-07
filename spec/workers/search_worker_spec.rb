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
    it "can call ref" do
      expect(SearchWorker.new(@search.id).clean_and_separate_words).to eq("won the grammys last year")
    end
    it "SearchWorker initializes with existing search_id" do
      expect{ SearchWorker.new(0)}.to raise_error(ArgumentError)
      expect{ SearchWorker.new(@search.id)}.to_not raise_error
    end
  end
  describe "SearchWorker can create keywords given search id" do
    before(:each) do
      @search = Search.create(
        search_type: "Song",
        text: "Won the grammys last year"
      )
    end
    it "creates new keywords" do
      expect(Keyword.count).to eq(0)
      SearchWorker.new(@search.id).create_keywords
      expect(Keyword.count).to eq(4)
    end
  end
end
