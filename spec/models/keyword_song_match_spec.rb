require 'rails_helper'

RSpec.describe KeywordSongMatch, type: :model do
  context "associations" do
    it{should belong_to(:keyword)}
    it{should belong_to(:song)}
  end
end
