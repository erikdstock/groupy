class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def format_month_year(time)
    time.strftime "%B %Y"
  end


  # CORS stuff we don't need right now
  # before_action :allow_cross_origin_requests

  # def preflight
  #   render nothing: true
  # end

  # private

  # def allow_cross_origin_requests
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Request-Method'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
  #   headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  #   headers['Access-Control-Max-Age'] = '1728000'
  # end
end
