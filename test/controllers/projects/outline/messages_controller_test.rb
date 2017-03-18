require 'test_helper'

class Projects::Outline::MessagesControllerTest < ActionController::TestCase
  test "should get reply" do
    get :reply
    assert_response :success
  end

end
