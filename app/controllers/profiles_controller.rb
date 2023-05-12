class ProfilesController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'topbar_layout'
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

  private
    def update_params
      params.permit(:email, :username, :bio, :avatar)
    end

    def get_profile
      email = params[:email]
      if User.where(email: email).present?
        User.find_by(email: email)
      else
        raise ActionController::RoutingError.new('Not Found')
    end        
  end
end

