require 'rails_helper'

RSpec.describe TrendService do
  before(:each) do
  end
  describe "intialization" do
    it "requires type and param to generate log" do
      expect{TrendService.new}.to raise_error(ArgumentError)
      expect{TrendService.new("Song", {})}.to_not raise_error
    end
    it "initializes with a connection" do
      aws = TrendService.new("Song", {})
      expect(aws.conn.class).to eq(Aws::S3::Client)
    end
  end
  describe "utility" do
    it "can build an object body for s3" do
      aws = TrendService.new("Song", {id: 1, name: "Daniel", info: "123"})
      aws_body = aws.build_puts_body
      expect(aws_body).to eq("id,1,name,Daniel,info,123")
    end
    it "can put an object to aws s3 bucket" do
      VCR.use_cassette("services/aws_service/trends_service_spec_1_putsobject", :allow_playback_repeats => true, :record => :new_episodes) do
        song = {
          type: "Song",
          id: 1052,
          title: "Lengthy Title",
          artist_name: "Kanye",
          playcount: 1,
          tags: ["Rap", "Kardashians"],
          corpus_word_count: 172,
          popular_words_in_corpus: ["swordfish", "sneakers", "butt"],
          keyword_matches: 3,
          important_keyword_matches: ["YE, sneakers, Keyword3"],
          possible_tags: [[15847, "Chicago"]],
          possible_taggings: 1,
        }
        aws = TrendService.new(song[:type], song).log_song_trends
        expect(aws.class).to eq(Seahorse::Client::Response)
      end
    end
  end
end
