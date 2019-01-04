require 'rails_helper'

RSpec.describe Song, type: :model do
  context "validations" do
    it{should validate_presence_of(:id)}
  end
  context "associations" do

  end
end
