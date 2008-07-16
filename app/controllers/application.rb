class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time   
  include AuthenticatedSystem
  protect_from_forgery # :secret => 'd933d30c61064fdaa66a94e4220fa1a8'
end
