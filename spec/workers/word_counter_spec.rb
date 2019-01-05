require 'rails_helper'
require_relative '../../lib/datapoints'

RSpec.describe WordCounter, type: :model do
  describe "initialization" do
    it "requires a type and id to intialize" do
      expect{ WordCounter.new }.to raise_error(ArgumentError)
      wc_true = WordCounter.new('Song', 4, ['strings'])
      expect(wc_true).to be_an_instance_of(WordCounter)
    end
  end
  describe "methods" do
    before(:each) do
      @refs = Datapoints::FakerData.products
    end
    context "Song" do
      it "refs are viewable as Strings" do
        word_counter = WordCounter.new('Song', 4, @refs)
        expect(word_counter.ref).to be_instance_of(String)
      end
      it "refs are totalled accurately with count_words" do
        word_counter = WordCounter.new('Song', 4, ["word1", "word2", "word2 word1 another.word"])
        expect(word_counter.ref).to be_instance_of(String)
        wcount = word_counter.count_words
        expect(wcount).to be_instance_of(Hash)
        expect(wcount.length).to eq(3)
        expect(wcount.keys).to eq(['word1', 'word2', 'another.word'])
        expect(wcount).to eq({'word1' => 2, 'word2' => 2, 'another.word' => 1})
      end
    end
  end
end
