require 'test_helper'

class AdminDeleteTest < ActionDispatch::IntegrationTest
  test 'regular admin does not get button to delete self' do
    login_as(@a6, scope: :admin)
    visit admin_path(@a6)
    assert page.has_no_link?('Delete', href: admin_path(@a6))
  end

  test 'super admin does not get button to delete self' do
    login_as(@a5, scope: :admin)
    visit admin_path(@a5)
    assert page.has_no_link?('Delete', href: admin_path(@a5))
  end

  test 'regular admin does not get button to delete super admin' do
    login_as(@a6, scope: :admin)
    visit admin_path(@a5)
    assert page.has_no_link?('Delete', href: admin_path(@a5))
  end

  test 'super admin can delete regular admin' do
    login_as(@a5, scope: :admin)
    visit root_path
    click_on 'Admin Index'
    assert_difference 'Admin.count', -1 do
      click_on 'whuntington'
      click_on 'Delete'
    end
    assert_text 'Admin deleted'
  end
end
