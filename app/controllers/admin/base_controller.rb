class Admin::BaseController < ActionController::Base
  protect_from_forgery
  layout 'admins'
  helper :all



  before_filter :authenticate_admin!
end
