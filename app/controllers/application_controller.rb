class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Clearance::Authentication
  protect_from_forgery
end
