class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  # helper_method :check_id

  def check_id
    unless request.headers['X-MT-TOKEN'] == ENV["X-MT-TOKEN"]
      not_found
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
