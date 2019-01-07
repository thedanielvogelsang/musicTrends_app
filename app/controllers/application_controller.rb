class ApplicationController < ActionController::Base
  
  helper_method :check_id

  def check_id
    unless request.headers['X-MT-TOKEN'] == "music.trends.use_94579d993011c92n373nd0mx9d"
      not_found
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
