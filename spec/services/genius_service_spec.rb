require 'rails_helper'

RSpec.describe GeniusService do
  before(:each) do
    @song_id = 128399
  end
  describe "Service Behaviors" do
    it "initializes with a connection to Genius" do
      api = GeniusService.new
      expect(api.conn.class).to eq(Faraday::Connection)
    end
  end
  context "#get_songs utility" do
    it "#get_songs can get list of songs given a query" do
      VCR.use_cassette "/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)
        assert_equal(20, api_return.length)
      end
    end
    it "#get_songs returns as array" do
      VCR.use_cassette "/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)
        assert_equal(api_return.class, Array)
      end
    end
    it "#get_songs returns list of songs" do
      VCR.use_cassette "/services/love" do
        query = "Love"
        api_return = GeniusService.new.get_songs(query)

        expect(/(\/songs)/.match(api_return.first[:api_path])).to be_truthy
        expect(/(\/artists)/.match(api_return.first[:api_path])).to be nil
      end
    end
  end
  context "#get_song_info utility" do
    it "#get_song_info returns single song given an id as Hash" do
      VCR.use_cassette "/services/chicago_25or624" do
          api_return = GeniusService.new.get_song_info(@song_id)
          assert_equal(Hash, api_return.class)
          assert_equal("Chicago’s 1971 hit from their 1970’s second album – Chicago (sometimes retroactively called Chicago II).",
                        api_return[:description][:dom][:children][0][:children][0]
                      )
      end
    end
    it "#get_song_info returns nil for bad ids" do
      VCR.use_cassette "/services/get_song_info_failed_song_id" do
          api_return = GeniusService.new.get_song_info(0)
          assert_nil(api_return)
      end
    end
  end
  context "#get_referents utility" do
    it "#get_referents returns an array of annotation objects given a song_id" do
      VCR.use_cassette "/services/britney" do
          api_return = GeniusService.new.get_referents(@song_id)
          assert_equal(Array, api_return.class)
          assert_equal("referent",
                        api_return.first[:_type]
                      )
          assert_equal(String,
                        api_return.last[:annotations][0][:body][:dom][:children][0][:children].join("").class
                      )
      end
    end
    it "#get_referents returns nil for bad ids" do
      VCR.use_cassette "/services/get_referents_failed_song_id" do
          api_return = GeniusService.new.get_referents(0)
          assert_nil(api_return)
      end
    end
  end
end
