require 'rails_helper'

RSpec.describe Api::V1::TagsController, type: :controller do
  context "before all request-header auth token" do
    before(:each) do
      headers = {'X-MT-TOKEN' => ENV['X-MT-TOKEN']}
      request.headers.merge! headers
      @tag = Tag.create(
        context: "High School",
        key_words: ["Pimple", "crush", "pizza", "football", "classes", "parties"]
      )
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
        expect(Tag.count).to eq(1)
        expect(JSON.parse(response.body).length).to eq(1)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: Tag.last.id}
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post :create, params: {tags: {context: "Day time shows", key_words: ["jerry springer", "maury", "Dr. Phil", "Judge Judy", "The Price is Right"]}}
        expect(response).to have_http_status(:success)
        expect(Tag.count).to eq(2)
      end
    end

    describe "DESTROY #destroy" do
      it "returns http success" do
        expect(Tag.count).to eq(1)
        delete :destroy, params: {id: @tag.id}
        expect(response).to have_http_status(:success)
        expect(Tag.count).to eq(0)
      end
    end

    describe "PUT/PATCH #update" do
      it "returns http success" do
        tag = Tag.find(@tag.id)
        expect(tag.key_words.length).to eq(6)
        put :update, params: {id: @tag.id, tags: {key_words: ["new keyword"]}}
        expect(response).to have_http_status(:success)
        updatedTag = Tag.find(@tag.id)
        expect tag.id = updatedTag.id
        expect(tag.key_words.length).to eq(6)
        expect(updatedTag.key_words.length).to eq(7)
      end
      it "returns http success" do
        tag = Tag.find(@tag.id)
        expect(tag.key_words.length).to eq(6)
        expect(tag.context).to eq("High School")
        put :update, params: {id: @tag.id, tags: {context: "New context"}}
        expect(response).to have_http_status(:success)
        updatedTag = Tag.find(@tag.id)
        expect(updatedTag.context).to eq("New context")
        expect(updatedTag.key_words.length).to eq(6)
      end
    end
  end
end
