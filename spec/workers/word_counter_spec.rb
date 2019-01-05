require 'rails_helper'

RSpec.describe WordCounter, type: :model do
  describe "initialization" do
    it "requires a type and id to intialize" do
      expect{ WordCounter.new }.to raise_error(ArgumentError)
      wc_true = WordCounter.new('Song', 4, ['strings'])
      expect(wc_true).to be_an_instance_of(WordCounter)
    end
  end
end
