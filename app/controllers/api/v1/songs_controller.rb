class Api::V1::SongsController < ApplicationController
  include ParamHelper
  before_action :check_id

  def index
    render json: Song.paginate(page: params[:page], :per_page => 10), status: 202, each_serializer: SongSerializer
  end

  def show
    if params[:id]
      render json: Song.find(params[:id]), status: 202, serializer: SongSerializer
    else
      render :file => "public/404", status: 404
    end
  end
end
