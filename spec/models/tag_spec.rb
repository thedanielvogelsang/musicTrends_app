require 'rails_helper'

RSpec.describe Tag, type: :model do
  context "validations" do
    it{should validate_presence_of(:context)}
    it{should validate_presence_of(:key_words)}
  end
  context "associations" do
    it{should have_many(:keyword_taggings)}
    it{should have_many(:keywords)}
  end
end
