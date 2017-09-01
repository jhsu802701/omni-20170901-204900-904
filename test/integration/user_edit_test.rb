# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ParameterLists
require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  # Edit all parameters except email
  def edit_all_but_email(u, uname, fname, lname, password_n, password_c)
    edit_user_start(u)
    fill_in('Username', with: uname)
    fill_in('First name', with: fname)
    fill_in('Last name', with: lname)
    fill_in('user_password', with: password_n)
    fill_in('user_password_confirmation', with: password_n)
    fill_in('Current password', with: password_c)
    click_button('Update')
    assert page.has_text?('Your account has been updated successfully.')
    click_on 'Edit Settings'
    page.assert_selector(:xpath, xpath_input_str(uname))
    page.assert_selector(:xpath, xpath_input_str(fname))
    page.assert_selector(:xpath, xpath_input_str(lname))
    click_on 'Logout'
    login_user(uname, password_n, false)
    assert page.has_text?('Signed in successfully.')
    click_on 'Logout'
  end

  # Edit all parameters, including email
  def edit_all(u, uname, e, fname, lname, password_n, password_c)
    edit_user_start(u)
    fill_in('Username', with: uname)
    fill_in('Email', with: e)
    fill_in('First name', with: fname)
    fill_in('Last name', with: lname)
    fill_in('user_password', with: password_n)
    fill_in('user_password_confirmation', with: password_n)
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

    login_user(uname, password_n, false)
    assert page.has_text?('Signed in successfully.')
    click_on 'Logout'
  end

  test 'user can access the page for editing settings' do
    login_as(@u1, scope: :user)
    visit root_path
    assert page.has_link?('Edit Settings', href: edit_user_registration_path(@u1))
    visit about_path
    assert page.has_link?('Edit Settings', href: edit_user_registration_path(@u1))
    visit contact_path
    assert page.has_link?('Edit Settings', href: edit_user_registration_path(@u1))
  end

  test 'user edit page has the expected content' do
    edit_user_start(@u1)
    assert page.has_css?('title', text: full_title('User Edit'), visible: false)
    assert page.has_css?('h1', text: 'User Edit')
    assert page.has_text?('password management program')
    assert page.has_text?('create much better passwords')
    assert page.has_link?('KeePassX', href: 'http://www.keepassx.org')
  end

  test 'user can edit all parameters besides email' do
    edit_all_but_email(@u1, 'jbond', 'James', 'Bond',
                       'You Only Live Twice', 'Goldfinger')
  end

  test 'user can edit all parameters, including email' do
    edit_all(@u1, 'jbond', '007@example.com',
             'James', 'Bond', 'You Only Live Twice', 'Goldfinger')
  end

  test 'user can delete self' do
    assert_difference 'User.count', -1 do
      edit_user_start(@u7)
      click_on 'Cancel my account'
      assert page.has_text?('Your account has been successfully cancelled.')
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ParameterLists
