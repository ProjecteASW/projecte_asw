class ProfileController < ApplicationController
  layout 'topbar_layout'
  def show
    @profile = get_profile
  end

  def edit
    # use this to populate a form in your view
    @profile = get_profile  
  end

  private
    def get_profile
      email = params[:email]
      if User.where(email: email).present?
        User.find_by(email: email)
      else
        raise "Error: Profile cannot be found"
    end        
  end
end

