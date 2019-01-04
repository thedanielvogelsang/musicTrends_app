require 'rails_helper'

RSpec.describe Api::V1::SongsController, type: :controller do
  before(:each) do
    @song_id = 128399
  end
  describe "GET #index" do
    it "#without query: returns 404 status" do
      get :index
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq("Try a different query, that one's stale")
    end
    it "#with query: returns http success and song items as json object" do
      VCR.use_cassette "/cassettes/controllers/chicago" do
        get :index, params: {query: "Chicago"}
        expect(response).to have_http_status(:success)
      end
    end
    it "#with query: returns results paginated at 10 per_page" do
      VCR.use_cassette("/cassettes/controllers/chicago", :allow_playback_repeats => true) do
        query = "Chicago"
        resp = GeniusService.new.get_songs(query)
        get :index, params: {query: query}
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).length).to eq(10)
        expect(resp.length).to eq(20)
      end
    end
  end

  describe "GET #show" do
    it "returns http success with errored song id" do
      VCR.use_cassette "/cassettes/services/failed_song_id" do
        get :show, params: {song_id: 0}
        expect(response).to have_http_status(202)
        expect(JSON.parse(response.body)).to eq(nil)
      end
    end
    it "returns http success with song id" do
      VCR.use_cassette "/cassettes/services/chicago_25or624" do
        get :show, params: {song_id: @song_id}
        expect(response).to have_http_status(:success)
      end
    end
  end

end
