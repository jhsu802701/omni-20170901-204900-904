require 'test_helper'

class UserDeleteTest < ActionDispatch::IntegrationTest
  def delete_user(u)
    visit user_path(u)
    assert_difference 'User.count', -1 do
      click_on 'Delete'
    end
    assert_text 'User deleted'
  end

  def check_delete(a)
    login_as(a, scope: :admin)
    delete_user(@u1)
    delete_user(@u2)
    delete_user(@u3)
    delete_user(@u4)
    delete_user(@u5)
    delete_user(@u6)
    delete_user(@u7)
  end

  test 'user does not get button to delete self' do
    login_as(@u1, scope: :user)
    visit user_path(@u1)
    assert page.has_no_link?('Delete', href: user_path(@u1))
  end

  test 'regular admin gets button to delete user' do
    check_delete(@a4)
  end

  test 'super admin gets button to delete user' do
    check_delete(@a1)
  end
end
