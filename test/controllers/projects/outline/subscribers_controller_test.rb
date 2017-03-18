require 'test_helper'

class Projects::Outline::SubscribersControllerTest < ActionController::TestCase
  setup do
    @projects_outline_subscriber = projects_outline_subscribers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects_outline_subscribers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create projects_outline_subscriber" do
    assert_difference('Projects::Outline::Subscriber.count') do
      post :create, projects_outline_subscriber: { phone: @projects_outline_subscriber.phone }
    end

    assert_redirected_to projects_outline_subscriber_path(assigns(:projects_outline_subscriber))
  end

  test "should show projects_outline_subscriber" do
    get :show, id: @projects_outline_subscriber
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @projects_outline_subscriber
    assert_response :success
  end

  test "should update projects_outline_subscriber" do
    patch :update, id: @projects_outline_subscriber, projects_outline_subscriber: { phone: @projects_outline_subscriber.phone }
    assert_redirected_to projects_outline_subscriber_path(assigns(:projects_outline_subscriber))
  end

  test "should destroy projects_outline_subscriber" do
    assert_difference('Projects::Outline::Subscriber.count', -1) do
      delete :destroy, id: @projects_outline_subscriber
    end

    assert_redirected_to projects_outline_subscribers_path
  end
end
