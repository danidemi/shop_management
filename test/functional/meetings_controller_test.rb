require 'test_helper'

class MeetingsControllerTest < ActionController::TestCase
  setup do
    @meeting = meetings(:one)
  end

  test "should show meeting" do
    get :show, :id => @meeting.to_param
    assert_response :success
  end

  test "should destroy meeting" do
    assert_difference('Meeting.count', -1) do
      delete :destroy, :id => @meeting.to_param
    end

    assert_redirected_to meetings_path
  end
end
