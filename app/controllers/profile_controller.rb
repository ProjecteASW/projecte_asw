class ProfileController < ApplicationController
  layout 'topbar_layout'
  def show
    @user = current_user
  end
end
