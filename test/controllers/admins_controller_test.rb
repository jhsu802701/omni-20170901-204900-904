# rubocop:disable Metrics/ClassLength
require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  # BEGIN: SHOW
  # BEGIN: show-public
  test 'should redirect profile page when not logged in' do
    get admin_path(@a1)
    assert_redirected_to root_path
    get admin_path(@a2)
    assert_redirected_to root_path
    get admin_path(@a3)
    assert_redirected_to root_path
    get admin_path(@a4)
    assert_redirected_to root_path
    get admin_path(@a5)
    assert_redirected_to root_path
    get admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: show-public

  # BEGIN: show-user
  test 'should redirect users from profile page' do
    sign_in @u1, scope: :user
    get admin_path(@a1)
    assert_redirected_to root_path
    get admin_path(@a2)
    assert_redirected_to root_path
    get admin_path(@a3)
    assert_redirected_to root_path
    get admin_path(@a4)
    assert_redirected_to root_path
    get admin_path(@a5)
    assert_redirected_to root_path
    get admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: show-user

  # BEGIN: show-regular_admin
  test 'should not redirect profile page when logged in as a regular admin' do
    sign_in @a4, scope: :admin
    get admin_path(@a1)
    assert :success
    get admin_path(@a2)
    assert :success
    get admin_path(@a3)
    assert :success
    get admin_path(@a4)
    assert :success
    get admin_path(@a5)
    assert :success
    get admin_path(@a6)
    assert :success
  end
  # END: show-regular_admin

  # BEGIN: show-super_admin
  test 'should not redirect profile page when logged in as a super admin' do
    sign_in @a1, scope: :admin
    get admin_path(@a1)
    assert :success
    get admin_path(@a2)
    assert :success
    get admin_path(@a3)
    assert :success
    get admin_path(@a4)
    assert :success
    get admin_path(@a5)
    assert :success
    get admin_path(@a6)
    assert :success
  end
  # END: show-super_admin
  # END: SHOW

  # BEGIN: INDEX
  # BEGIN: index-public
  test 'should redirect index page when not logged in' do
    get admins_path
    assert_redirected_to root_path
  end
  # END: index-public

  # BEGIN: index-user
  test 'should redirect index page when logged in as a user' do
    sign_in @u1, scope: :user
    get admins_path
    assert_redirected_to root_path
  end
  # END: index-user

  # BEGIN: index-regular_admin
  test 'should not redirect index page when logged in as a regular admin' do
    sign_in @a4, scope: :admin
    get admins_path
    assert :success
  end
  # END: index-regular_admin

  # BEGIN: index-super_admin
  test 'should not redirect index page when logged in as a super admin' do
    sign_in @a1, scope: :admin
    get admins_path
    assert :success
  end
  # END: index-super_admin
  # END: INDEX

  # BEGIN: DELETE
  # BEGIN: delete-public
  test 'should not allow visitor to delete admin' do
    delete admin_path(@a5)
    assert_redirected_to root_path
    delete admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: delete-public

  # BEGIN: delete-user
  test 'should not allow user to delete admin' do
    sign_in @u1, scope: :user
    delete admin_path(@a5)
    assert_redirected_to root_path
    delete admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: delete-user

  # BEGIN: delete-self-regular
  # NOTE: regular admin can delete self through edit registration form
  test 'should not allow regular admin to delete self' do
    sign_in @a6, scope: :admin
    delete admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: delete-self

  # BEGIN: delete-self-super
  # NOTE: super admin can delete self through edit registration form
  test 'should not allow super admin to delete self' do
    sign_in @a5, scope: :admin
    delete admin_path(@a5)
    assert_redirected_to root_path
  end
  # END: delete-self

  # BEGIN: delete-regular-regular
  test 'should not allow regular admin to delete another regular admin' do
    sign_in @a4, scope: :admin
    delete admin_path(@a6)
    assert_redirected_to root_path
  end
  # END: delete-regular-regular

  # BEGIN: delete-regular_super
  test 'should not allow regular admin to delete super admin' do
    sign_in @a6, scope: :admin
    delete admin_path(@a5)
    assert_redirected_to root_path
  end
  # END: delete-regular_super

  # BEGIN: delete-super-super
  test 'should not allow super admin to delete another super admin' do
    sign_in @a1, scope: :admin
    delete admin_path(@a5)
    assert_redirected_to root_path
  end
  # END: delete-super-super

  # BEGIN: delete-super_regular
  test 'should allow super admin to delete regular admin' do
    sign_in @a5, scope: :admin
    delete admin_path(@a6)
    assert :success
    assert_redirected_to admins_path
  end
  # END: delete-super_regular_super
  # END: DELETE
end
# rubocop:enable Metrics/ClassLength
