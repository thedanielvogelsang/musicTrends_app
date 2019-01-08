class Api::V1::TagsController < ApplicationController
  before_action :check_id

  def index
    render json: Tag.paginate(page: params[:page], :per_page => 10), each_serializer: TagIndexSerializer
  end

  def show
    if params[:id]
      render json: Tag.find(params[:id]), status: 202, serializer: TagShowSerializer
    else
      render json: {error: "Tag does not exist"}, status: 404
    end
  end

  def create
    if params[:tags]
      if tag = Tag.create(safe_params)
        render json: tag, status: 202
        TagJob.perform_async(tag.id)
      else
        render json: {errors: tag.errors.messages}, status: 404
      end
    else
      render json: {error: "Something went wrong"}, status: 202
    end
  end

  def destroy
    tag = Tag.destroy(params[:id])
    render json: tag, status: 202
  end

  def update
    if safe_params && params[:id]
      if params[:tags][:key_words]
        tag = Tag.find(params[:id]).update_keywords(safe_params)
      else
        if tag = Tag.update(params[:id], safe_params)
          render json: tag, status: 202
        else
          render json: {errors: tag.errors.messages}, status: 404
        end
      end
    else
      render json: {error: "Something went wrong"}, status: 404
    end
  end

  private

    def safe_params
      params.require(:tags).permit(:context, :key_words => [])
    end
end
