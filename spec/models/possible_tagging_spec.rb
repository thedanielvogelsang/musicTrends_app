require 'rails_helper'

RSpec.describe PossibleTagging, type: :model do
  context "associations" do
    it{should belong_to(:tag)}
    it{should belong_to(:song)}
  end
end
