require 'test_helper'

class AdminSignupTest < ActionDispatch::IntegrationTest
  test 'Prevent signing up as admin' do
    visit new_admin_registration_path

    # Flash message
    assert page.has_text?('Admin sign-ups are disabled.')

    # Home page
    assert page.has_css?('title', text: full_title(''), visible: false)
    assert page.has_css?('h1', text: 'Home')
  end
end
