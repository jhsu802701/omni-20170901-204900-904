require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest
  test 'home page has expected content' do
    visit root_path
    assert page.has_css?('title', text: full_title(''), visible: false)
    assert page.has_css?('h1', text: 'Home')
    assert page.has_text?('Welcome to Temporary OmniAuth App')
    assert page.has_css?('small', text: 'Temporary OmniAuth App by Somebody')
  end

  test 'about page has expected content' do
    visit about_path
    assert page.has_css?('title', text: full_title('About'), visible: false)
    assert page.has_css?('h1', text: 'About')
    assert page.has_text?('Describe your site here.')
    assert page.has_css?('small', text: 'Temporary OmniAuth App by Somebody')
  end

  test 'contact page has expected content' do
    visit contact_path
    assert page.has_css?('title', text: full_title('Contact'), visible: false)
    assert page.has_css?('h1', text: 'Contact')
    assert page.has_text?('rubyist@jasonhsu.com')
    assert page.has_css?('small', text: 'Temporary OmniAuth App by Somebody')
  end

  test 'home page provides access to the about page' do
    visit root_path
    click_on 'About'
    assert page.has_css?('title', text: full_title('About'), visible: false)
    assert page.has_css?('h1', text: 'About')
  end

  test 'home page provides access to the contact page' do
    visit root_path
    click_on 'Contact'
    assert page.has_css?('title', text: full_title('Contact'), visible: false)
    assert page.has_css?('h1', text: 'Contact')
  end

  test 'about page provides access to the home page' do
    visit about_path
    click_on 'Home'
    assert page.has_css?('title', text: full_title(''), visible: false)
    assert page.has_css?('h1', text: 'Home')
  end

  test 'about page provides access to the contact page' do
    visit about_path
    click_on 'Contact'
    assert page.has_css?('title', text: full_title('Contact'), visible: false)
    assert page.has_css?('h1', text: 'Contact')
  end

  test 'contact page provides access to the home page' do
    visit contact_path
    click_on 'Home'
    assert page.has_css?('title', text: full_title(''), visible: false)
    assert page.has_css?('h1', text: 'Home')
  end

  test 'contact page provides access to the about page' do
    visit contact_path
    click_on 'About'
    assert page.has_css?('title', text: full_title('About'), visible: false)
    assert page.has_css?('h1', text: 'About')
  end
end
