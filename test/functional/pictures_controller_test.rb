require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  setup do
    @picture = pictures(:one)
    @album   = album(:vacation)
    @user    = users(:tate)
    @default_params = { profile_name: @user.profile_name, album_id: @album.id }
  end

  test "should get index" do
    get :index, @default_params
    assert_response :success
    assert_not_nil assigns(:pictures)
  end

  test "should get new" do
    sign_in users(:tate)
    get :new, @default_params
    assert_response :success
  end

  test "should create picture" do
    sign_in users(:tate)
    assert_difference('Picture.count') do
      post :create, @default_params.merge(picture: { caption: @picture.caption, description: @picture.description })
    end

    assert_redirected_to album_pictures_path(@user.profile_name, @album.id)
  end

  test "should show picture" do
    get :show, @default_params.marge(id: @picture)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:tate)
    get :edit, @default_params.marge(id: @picture)
    assert_response :success
  end

  test "should update picture" do
    sign_in users(:tate)
    put :update, @default_params.marge(id: @picture, picture: { caption: @picture.caption, description: @picture.description })
    assert_redirected_to album_pictures_path(@user.profile_name, @album.id) 
  end

  test "should destroy picture" do
    sign_in users(:tate)
    assert_difference('Picture.count', -1) do
      delete :destroy, @default_params.marge(id: @picture)
    end

    assert_redirected_to album_pictures_path
  end
end
