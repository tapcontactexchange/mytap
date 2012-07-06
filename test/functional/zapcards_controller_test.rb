require 'test_helper'

class ZapcardsControllerTest < ActionController::TestCase
  setup do
    @zapcard = zapcards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zapcards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zapcard" do
    assert_difference('Zapcard.count') do
      post :create, zapcard: {  }
    end

    assert_redirected_to zapcard_path(assigns(:zapcard))
  end

  test "should show zapcard" do
    get :show, id: @zapcard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @zapcard
    assert_response :success
  end

  test "should update zapcard" do
    put :update, id: @zapcard, zapcard: {  }
    assert_redirected_to zapcard_path(assigns(:zapcard))
  end

  test "should destroy zapcard" do
    assert_difference('Zapcard.count', -1) do
      delete :destroy, id: @zapcard
    end

    assert_redirected_to zapcards_path
  end
end
