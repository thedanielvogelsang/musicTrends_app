require 'rails_helper'

RSpec.describe Song, type: :model do
  context "validations" do
    it {should validate_presence_of(:id)}
  end
  context "associations" do
    it {should have_many(:song_searches)}
    it {should have_many(:searches)}
  end
end
