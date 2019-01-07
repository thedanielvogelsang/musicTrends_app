class ApplicationController < ActionController::Base

  helper_method :check_id

  def check_id
    unless request.headers['X-MT-TOKEN'] == ENV["X-MT-TOKEN"]
      puts 'token:'
      puts ENV["X-MT-TOKEN"]
      puts request.headers['X-MT-TOKEN']
      not_found
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
