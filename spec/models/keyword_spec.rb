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
  end
end
