class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :resource

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :language


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit! }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit! }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit! }
    end

  private
    def language
      if current_user
        I18n.locale = current_user.language 
      elsif cookies[:locale].nil? 
        cookies[:locale]="ru" 
      else 
        I18n.locale = cookies[:locale]
      end
    end

    def after_sign_in_path_for(resource_or_scope)
      if current_user
        cookies["_validation_token_key"] = Digest::MD5.hexdigest("#{session[:session_id]}:#{current_user.id}")
        stored_session = JSON.generate({ user_id: current_user.id })
        $redis.hset("olympicSession", cookies["_validation_token_key"], stored_session)
      end
      root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      if cookies["_validation_token_key"].present?
        $redis.hdel("olympicSession", cookies["_validation_token_key"])
      end
      root_path
    end
    
end
