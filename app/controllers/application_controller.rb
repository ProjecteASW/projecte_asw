class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  def after_sign_in_path_for(resource)
    '/projects'
  end

  def authenticate
    if request.format.html? 
      authenticate_user!
    else
      if request.method != "GET"
        if request.headers["HTTP_API_KEY"].nil?
          raise "API_KEY not provided."
        else
          user = User.find_by_api_key(request.headers["HTTP_API_KEY"])
          if user.nil?
            raise "The API_KEY does not belong to any user."
          end
        end
      end
    end
  end
end