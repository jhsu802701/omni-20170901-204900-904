# rubocop:disable Metrics/ParameterLists
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
require 'test_helper'

class AdminEditTest < ActionDispatch::IntegrationTest
  # Edit all parameters except email
  def edit_all_but_email(a, uname, fname, lname, password_n, password_c)
    edit_admin_start(a)
    fill_in('Username', with: uname)
    fill_in('First name', with: fname)
    fill_in('Last name', with: lname)
    fill_in('admin_password', with: password_n)
    fill_in('admin_password_confirmation', with: password_n)
    fill_in('Current password', with: password_c)
    click_button('Update')
    assert page.has_text?('Your account has been updated successfully.')
    click_on 'Edit Settings'
    page.assert_selector(:xpath, xpath_input_str(uname))
    page.assert_selector(:xpath, xpath_input_str(fname))
    page.assert_selector(:xpath, xpath_input_str(lname))
    click_on 'Logout'
    login_admin(uname, password_n, false)
    assert page.has_text?('Signed in successfully.')
    click_on 'Logout'
  end

  # Edit all parameters, including email
  def edit_all(a, uname, e, fname, lname, password_n, password_c)
    edit_admin_start(a)
    fill_in('Username', with: uname)
    fill_in('Email', with: e)
    fill_in('First name', with: fname)
    fill_in('Last name', with: lname)
    fill_in('admin_password', with: password_n)
    fill_in('admin_password_confirmation', with: password_n)
    fill_in('Current password', with: password_c)
    click_button('Update')
    assert page.has_text?('You updated your account successfully,')
    assert page.has_text?('but we need to verify your new email address.')
    assert page.has_text?('Please check your email and follow the confirm link')
    assert page.has_text?('to confirm your new email address.')

    # Confirm new email address
    open_email(e)
    current_email.click_link 'Confirm my account'
    assert page.has_text?('Your email address has been successfully confirmed.')
    clear_emails # Clear the message queue

    # Check new settings
    visit root_path
    click_on 'Edit Settings'
    page.assert_selector(:xpath, xpath_input_str(uname))
    page.assert_selector(:xpath, xpath_input_str(fname))
    page.assert_selector(:xpath, xpath_input_str(lname))
    click_on 'Logout'

    login_admin(uname, password_n, false)
    assert page.has_text?('Signed in successfully.')
    click_on 'Logout'
  end

  test 'super admin can access the page for editing settings' do
    login_as(@a1, scope: :admin)
    visit root_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a1))
    visit about_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a1))
    visit contact_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a1))
  end

  test 'regular admin can access the page for editing settings' do
    login_as(@a4, scope: :admin)
    visit root_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a4))
    visit about_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a4))
    visit contact_path
    assert page.has_link?('Edit Settings', href: edit_admin_registration_path(@a4))
  end

  test 'admin edit page has the expected content for super admin' do
    edit_admin_start(@a1)
    assert page.has_css?('title', text: full_title('Admin Edit'), visible: false)
    assert page.has_css?('h1', text: 'Admin Edit')
    assert page.has_text?('password management program')
    assert page.has_text?('create much better passwords')
    assert page.has_link?('KeePassX', href: 'http://www.keepassx.org')
  end

  test 'admin edit page has the expected content for regular admin' do
    edit_admin_start(@a4)
    assert page.has_css?('title', text: full_title('Admin Edit'), visible: false)
    assert page.has_css?('h1', text: 'Admin Edit')
    assert page.has_text?('password management program')
    assert page.has_text?('create much better passwords')
    assert page.has_link?('KeePassX', href: 'http://www.keepassx.org')
  end

  test 'super admin can edit all parameters besides email' do
    edit_all_but_email(@a1, 'rwitherspoon', 'Reese', 'Witherspoon',
                       'Just Like Heaven', 'endorphins')
  end

  test 'regular admin can edit all parameters besides email' do
    edit_all_but_email(@a4, 'jcoolidge', 'Jennifer', 'Coolidge',
                       'A Cinderella Story', "Neptune's Beauty Nook")
  end

  test 'super admin can edit all parameters, including email' do
    edit_all(@a1, 'rwitherspoon', 'reese_witherspoon@example.com',
             'Reese', 'Witherspoon', 'Just Like Heaven', 'endorphins')
  end

  test 'regular admin can edit all parameters, including email' do
    edit_all(@a4, 'jcoolidge', 'jennifer_coolidge@example.com',
             'Jennifer', 'Coolidge', 'A Cinderella Story',
             "Neptune's Beauty Nook")
  end

  test 'super admin can delete self' do
    assert_difference 'Admin.count', -1 do
      edit_admin_start(@a5)
      click_on 'Cancel my account'
      assert page.has_text?('Your account has been successfully cancelled.')
    end
  end

  test 'regular admin can delete self' do
    assert_difference 'Admin.count', -1 do
      edit_admin_start(@a6)
      click_on 'Cancel my account'
      assert page.has_text?('Your account has been successfully cancelled.')
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ParameterLists
