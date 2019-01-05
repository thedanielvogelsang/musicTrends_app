require 'rails_helper'

RSpec.describe Keyword, type: :model do
  context "validations" do
    it{should validate_presence_of(:phrase)}
  end
  context "associations" do
    it{should have_many(:keyword_taggings)}
    it{should have_many(:tags)}
  end
  context "before_save" do
    it "saves with phrase downcased" do
      key = Keyword.create(phrase: "Capitalized")
      expect(Keyword.count).to eq(1)
      expect(key.phrase).to eq("capitalized")
    end
    it "will NOT double record if both words ARENT downcased" do
      key = Keyword.find_or_create_by(phrase: "Capitalized")
      key2 = Keyword.find_or_create_by(phrase: "Capitalized")

      expect(Keyword.count).to eq(1)
      expect(key.phrase).to eq("capitalized")
      expect(key2.phrase).to eq("capitalized")
    end
    it "will NOT double record if SECOND word ISNT downcased" do
      key = Keyword.find_or_create_by(phrase: "capitalized")
      key2 = Keyword.find_or_create_by(phrase: "Capitalized")

      expect(Keyword.count).to eq(1)
      expect(key.phrase).to eq("capitalized")
      expect(key2.phrase).to eq("capitalized")
    end
    it 'will NOT double up words if both are downcased' do
      key = Keyword.find_or_create_by(phrase: "capitalized")
      key2 = Keyword.find_or_create_by(phrase: "capitalized")

      expect(Keyword.count).to eq(1)
      expect(key.phrase).to eq("capitalized")
      expect(key2.phrase).to eq("capitalized")
    end
    it "will NOT double up if second word is downcased" do
      key = Keyword.find_or_create_by(phrase: "Capitalized")
      key2 = Keyword.find_or_create_by(phrase: "capitalized")

      expect(Keyword.count).to eq(1)
      expect(key.phrase).to eq("capitalized")
      expect(key2.phrase).to eq("capitalized")
    end
  end
end
