class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate

  class APIKeyNotProvidedError < StandardError
  end

  class APIKeyDoesNotBelongError < StandardError
  end

  rescue_from APIKeyNotProvidedError, with: :api_key_not_provided
  rescue_from APIKeyDoesNotBelongError, with: :api_key_not_provided

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
          raise APIKeyNotProvidedError.new("API_KEY not provided.")
        else
          user = User.find_by_api_key(request.headers["HTTP_API_KEY"])
          if user.nil?
            raise APIKeyDoesNotBelongError.new("The API_KEY does not belong to any user.")
          end
        end
      end
    end
  end

  def api_key_not_provided
    respond_to do |format|
      format.json { render json: {'error': 'API_KEY not provided or it does not belong to any user'}, status: 401}
      format.html { raise ActionController::RoutingError.new('Not Found') }
    end
  end

end