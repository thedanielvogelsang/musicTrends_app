require 'rails_helper'

RSpec.describe Api::V1::SongsController, type: :controller do
  context "WITHOUT proper authorization" do
    before(:each) do
      @song = Song.create(
        id: 1052,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Brittney Spears",
        annotation_ct: 3,
      )
    end
    describe "GET #index" do
      it "it can't connect and returns a 404" do
        expect{get :index}.to raise_error(ActionController::RoutingError)
        expect(response).to have_http_status(200)
      end
    end
  end
  context "with proper authorization" do
    before(:each) do
      headers = {'X-MT-TOKEN' => ENV['X-MT-TOKEN']}
      request.headers.merge! headers
      @song = Song.create(
        id: 1052,
        title: "Song Title",
        artist_id: 12,
        artist_name: "Brittney Spears",
        annotation_ct: 3,
      )
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: @song.id}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
