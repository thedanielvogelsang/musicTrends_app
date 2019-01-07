class Api::V1::TagsController < ApplicationController
  before_action :check_id

  def index
    render json: Tag.all, each_serializer: TagIndexSerializer
  end

  def show
    if check_id && params[:id]
      render json: Tag.find(param[:id]), status: 202, serializer: TagShowSerializer
    else
      render json: {error: "Medication does not exist"}, status: 404
    end
  end

  def create
  end

  def destroy
  end

  def update
  end
end
