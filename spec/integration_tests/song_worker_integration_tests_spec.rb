require 'rails_helper'


RSpec.describe SongWorker, type: :model do
  context "integration tests" do
    describe "with pre-existing song without referents" do
      before(:each) do
        @song = Song.create(
          id: 1052,
          title: "Song Title",
          artist_id: 12,
          artist_name: "Britney Spears",
          annotation_ct: 3,
          word_dict: {"Previous Keyword" => 1, "racetrack" => 2}
        )
      end
      it "#can create keywords from products, buzzwords,
                          names, high_frequency words, artist/title;
              word_dict and referents ALL with one command" do

      end
    end
  end
end
