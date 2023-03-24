require "test_helper"

class UserSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get user_profile" do
    get user_settings_user_profile_url
    assert_response :success
  end

  test "should get user_change_password" do
    get user_settings_user_change_password_url
    assert_response :success
  end

  test "should get mail_notifications" do
    get user_settings_mail_notifications_url
    assert_response :success
  end
end
