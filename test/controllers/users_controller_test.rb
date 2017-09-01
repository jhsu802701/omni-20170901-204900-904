# rubocop:disable Metrics/ClassLength
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # BEGIN: SHOW
  # BEGIN: show-public
  test 'should redirect profile page when not logged in' do
    get user_path(@u1)
    assert_redirected_to root_path
    get user_path(@u2)
    assert_redirected_to root_path
    get user_path(@u3)
    assert_redirected_to root_path
    get user_path(@u4)
    assert_redirected_to root_path
    get user_path(@u5)
    assert_redirected_to root_path
    get user_path(@u6)
    assert_redirected_to root_path
    get user_path(@u7)
    assert_redirected_to root_path
  end
  # END: show-public

  # BEGIN: show-other_user
  test 'should redirect users from profiles other than their own' do
    sign_in @u1, scope: :user
    get user_path(@u2)
    assert_redirected_to root_path
    get user_path(@u3)
    assert_redirected_to root_path
    get user_path(@u4)
    assert_redirected_to root_path
    get user_path(@u5)
    assert_redirected_to root_path
    get user_path(@u6)
    assert_redirected_to root_path
    get user_path(@u7)
    assert_redirected_to root_path
  end
  # END: show-other_user

  # BEGIN: show-self
  test 'should not redirect users from their own profiles' do
    sign_in @u1, scope: :user
    get user_path(@u1)
    assert :success
  end
  # END: show-self

  # BEGIN: show-regular_admin
  test 'should not redirect profile page when logged in as a regular admin' do
    sign_in @a4, scope: :admin
    get user_path(@u1)
    assert :success
    get user_path(@u2)
    assert :success
    get user_path(@u3)
    assert :success
    get user_path(@u4)
    assert :success
    get user_path(@u5)
    assert :success
    get user_path(@u6)
    assert :success
    get user_path(@u7)
    assert :success
  end
  # END: show-regular_admin

  # BEGIN: show-super_admin
  test 'should not redirect profile page when logged in as a super admin' do
    sign_in @a1, scope: :admin
    get user_path(@u1)
    assert :success
    get user_path(@u2)
    assert :success
    get user_path(@u3)
    assert :success
    get user_path(@u4)
    assert :success
    get user_path(@u5)
    assert :success
    get user_path(@u6)
    assert :success
    get user_path(@u7)
    assert :success
  end
  # END: show-super_admin
  # END: SHOW

  # BEGIN: INDEX
  # BEGIN: index public
  test 'should redirect index page when not logged in' do
    get users_path
    assert_redirected_to root_path
  end
  # END: index public

  # BEGIN: index user
  test 'should redirect index page when logged in as a user' do
    sign_in @u1, scope: :user
    get users_path
    assert_redirected_to root_path
  end
  # END: index user

  # BEGIN: index regular admin
  test 'should not redirect index page when logged in as a regular admin' do
    sign_in @a4, scope: :admin
    get users_path
    assert :success
  end
  # END: index regular admin

  # BEGIN: index super admin
  test 'should not redirect index page when logged in as a super admin' do
    sign_in @a1, scope: :admin
    get users_path
    assert :success
  end
  # END: index super admin
  # END: INDEX

  # BEGIN: DELETE
  # BEGIN: delete-public
  test 'should not allow visitor to delete user' do
    delete user_path(@u7)
    assert_redirected_to root_path
  end
  # END: delete-public

  # BEGIN: delete-other_user
  test 'should not allow user to delete another user' do
    sign_in @u1, scope: :user
    delete user_path(@u7)
    assert_redirected_to root_path
  end
  # END: delete-other_user

  # BEGIN: delete-self
  # NOTE: User can delete self through edit registration form.
  test 'should not allow user to delete self' do
    sign_in @u7, scope: :user
    delete user_path(@u7)
    assert_redirected_to root_path
  end
  # END: delete-self

  # BEGIN: delete-regular_admin
  test 'should allow regular admin to delete user' do
    sign_in @a4, scope: :admin
    delete user_path(@u7)
    assert :success
    assert_redirected_to users_path
  end
  # END: delete-regular_admin

  # BEGIN: delete-super_admin
  test 'should allow super admin to delete user' do
    sign_in @a1, scope: :admin
    delete user_path(@u7)
    assert :success
    assert_redirected_to users_path
  end
  # END: delete-super_admin
  # END: DELETE
end
# rubocop:enable Metrics/ClassLength
