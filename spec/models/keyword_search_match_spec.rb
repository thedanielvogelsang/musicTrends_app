require 'rails_helper'

RSpec.describe KeywordSearchMatch, type: :model do
  context "associations" do
    it{should belong_to(:keyword)}
    it{should belong_to(:search)}
  end
end
