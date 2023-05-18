class ProfilesController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'topbar_layout'

  class ProfileNotFoundError < StandardError
  end
  class NotYourProfileError < StandardError
  end

  rescue_from ProfileNotFoundError, with: :user_not_found
  rescue_from NotYourProfileError, with: :not_your_profile

  def show
    @profile = get_profile
    @timelineEvents = TimelineEvent.where(user: @profile).order(created_at: :desc)
    respond_to do |format|
      format.json { render json: @profile, serializer: UserSerializer }
      format.html { render :show }
    end
  end

  def issues_watched
    @profile = get_profile
    @watchedIssues = WatchedIssue.where(user: @profile)
  end

  def edit
    @profile = get_profile  
  end

  def update
    @profile = get_profile
    if !request.format.html? 
      user = User.find_by_api_key(request.headers["HTTP_API_KEY"])
      if user.email != @profile.email
        raise NotYourProfileError.new("No es pot editar un perfil que no sigui el teu.")
      end
    end
    respond_to do |format|
      if @profile.update(update_params)
        format.json { render json: @profile, serializer: UserSerializer }
        format.html { redirect_to profile_page_path(@profile.email), notice: "Profile updated successfully." }
      else
        format.json { render json: @profile, serializer: UserSerializer }
        format.html { redirect_to profile_page_path(@profile.email), notice: "Profile could not be updated" }
      end
    end
  end

  def api_key
    @profile = get_profile
  end

  private
    def update_params
      params.permit(:email, :username, :bio, :avatar)
    end

    def get_profile
      email = params[:email]
      if User.where(email: email).present?
        User.find_by(email: email)
      else
        raise ProfileNotFoundError.new('User not found')
      end   
    end

    def user_not_found
      respond_to do |format|
        format.json { render json: {'error': 'User not found'}, status: 404}
        format.html { raise ActionController::RoutingError.new('Not Found') }
      end
    end

    def not_your_profile
      respond_to do |format|
        format.json { render json: {'error': 'No es pot editar un perfil que no sigui el teu.'}, status: 403}
        format.html { raise ActionController::RoutingError.new('Not Found') }
      end
    end
end

