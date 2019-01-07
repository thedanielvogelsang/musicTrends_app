class Api::V1::SearchesController < ApplicationController
  before_action :check_id
  def index
    render json: Search.paginate(page: params[:page], per_page: 10), status: 202
  end

  def show
    if params[:id]
      if search = Search.find(params[:id])
        render json: search, status: 202
      else
        render json: {error: "Record not found"}, status: 404
      end
    else
      render :file => 'public/404.html'
    end
  end
end
