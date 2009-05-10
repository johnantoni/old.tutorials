require 'test_helper'

class BrandsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:brands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create brand" do
    assert_difference('Brand.count') do
      post :create, :brand => { }
    end

    assert_redirected_to brand_path(assigns(:brand))
  end

  test "should show brand" do
    get :show, :id => brands(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => brands(:one).id
    assert_response :success
  end

  test "should update brand" do
    put :update, :id => brands(:one).id, :brand => { }
    assert_redirected_to brand_path(assigns(:brand))
  end

  test "should destroy brand" do
    assert_difference('Brand.count', -1) do
      delete :destroy, :id => brands(:one).id
    end

    assert_redirected_to brands_path
  end
end
