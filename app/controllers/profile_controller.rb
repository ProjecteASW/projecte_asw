class ProfileController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'topbar_layout'
  def show
    @profile = get_profile
  end

  def edit
    # use this to populate a form in your view
    @profile = get_profile  
  end

  def update
    @profile = get_profile
    respond_to do |format|
      if @profile.update(update_params)
        format.html { redirect_to "/profile/" + @profile.email, notice: "Profile updated successfully." }
      else
        format.html { redirect_to "/profile/" + @profile.email, notice: "Profile could not be updated" }
      end
    end
  end

  private
    def update_params
      params.permit(:email, :username, :bio)
    end

    def get_profile
      email = params[:email]
      if User.where(email: email).present?
        User.find_by(email: email)
      else
        raise "Error: Profile cannot be found"
    end        
  end
end

