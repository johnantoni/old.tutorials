require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, :contact => { }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, :id => contacts(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => contacts(:one).id
    assert_response :success
  end

  test "should update contact" do
    put :update, :id => contacts(:one).id, :contact => { }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, :id => contacts(:one).id
    end

    assert_redirected_to contacts_path
  end
end
