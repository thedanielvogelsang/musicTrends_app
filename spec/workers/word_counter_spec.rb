require 'rails_helper'
require_relative '../../lib/datapoints'

RSpec.describe WordCounter, type: :model do
  describe "initialization" do
    it "requires a type and id to intialize" do
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
      it "refs are totalled accurately with #count_words" do
        word_counter = WordCounter.new('Song', 4, ["word1", "word2", "word2 word1 another.word"])
        expect(word_counter.ref).to be_instance_of(String)
        wcount = word_counter.count_words
        expect(wcount).to be_instance_of(Hash)
        expect(wcount.length).to eq(3)
        expect(wcount.keys).to eq(['word1', 'word2', 'anotherword'])
        expect(wcount).to eq({'word1' => 2, 'word2' => 2, 'anotherword' => 1})
      end
      it "refs are totalled accurately even with odd annotations" do
        word_counter = WordCounter.new('Song', 4, ["word1", {:tag => 2}, "word2 word1 another.word", ['word'], 'word2'+'word1'])
        expect(word_counter.ref).to be_instance_of(String)
        wcount = word_counter.count_words
        expect(wcount).to be_instance_of(Hash)
        expect(wcount.length).to eq(4)
        expect(wcount.keys).to eq(['word1', 'word2', 'anotherword', 'word2word1'])
        expect(wcount).to eq({'word1' => 2, 'word2' => 1, 'anotherword' => 1, 'word2word1' => 1})
      end
    end
    context "instance methods" do
      it "without type or id can return word_count from string" do
        words = "I don't care betty, you don't have a right! Betty!"
        word_Count = WordCounter.new(nil, nil, words).count_words
        expect(word_Count['betty']).to eq(2)
        expect(word_Count['dont']).to eq(2)
        expect(Keyword.count).to eq(0)
      end
    end
  end
end
