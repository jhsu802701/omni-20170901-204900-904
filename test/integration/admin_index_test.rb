require 'test_helper'

class AdminIndexTest < ActionDispatch::IntegrationTest
  def check_index_disabled
    visit admins_path
    assert page.has_css?('title', text: full_title(''),
                                  visible: false)
    assert page.has_css?('h1', text: 'Home', visible: false)
  end

  def check_index_disabled_for_user(u)
    login_as(u, scope: :user)
    check_index_disabled
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def check_index_enabled
    visit admins_path
    assert page.has_css?('title', text: full_title('Admin Index'),
                                  visible: false)
    assert page.has_css?('h1', text: 'Admin Index')
    assert page.has_text?('Elle')
    assert page.has_text?('Woods')
    assert page.has_text?('Vivian')
    assert page.has_text?('Kensington')
    assert page.has_text?('Emmett')
    assert page.has_text?('Richmond')
    assert page.has_text?('Paulette')
    assert page.has_text?('Bonafonte')
    assert page.has_text?('Professor')
    assert page.has_text?('Callahan')
    assert page.has_text?('Warner')
    assert page.has_text?('Huntington')
    assert page.has_text?('elle_woods@example.com')
    assert page.has_text?('vivian_kensingston@example.com')
    assert page.has_text?('emmett_richmond@example.com')
    assert page.has_text?('paulette_bonafonte@example.com')
    assert page.has_text?('professor_callahan@example.com')
    assert page.has_text?('warner_huntington@example.com')

    # Verify that index page provides access to profile pages
    assert page.has_link?('ewoods', href: admin_path(@a1))
    assert page.has_link?('elle_woods@example.com', href: admin_path(@a1))
    assert page.has_link?('vkensington', href: admin_path(@a2))
    assert page.has_link?('vivian_kensingston@example.com', href: admin_path(@a2))
    assert page.has_link?('erichmond', href: admin_path(@a3))
    assert page.has_link?('emmett_richmond@example.com', href: admin_path(@a3))
    assert page.has_link?('pbonafonte', href: admin_path(@a4))
    assert page.has_link?('paulette_bonafonte@example.com', href: admin_path(@a4))
    assert page.has_link?('pcallahan', href: admin_path(@a5))
    assert page.has_link?('professor_callahan@example.com', href: admin_path(@a5))
    assert page.has_link?('whuntington', href: admin_path(@a6))
    assert page.has_link?('warner_huntington@example.com', href: admin_path(@a6))

    # Verify that root page provides access to index page
    click_on 'Home'
    assert page.has_link?('Admin Index', href: admins_path)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  test 'admins index page is not accessible to visitors' do
    check_index_disabled
  end

  test 'admins index page is not accessible to users' do
    check_index_disabled_for_user(@u1)
    check_index_disabled_for_user(@u2)
    check_index_disabled_for_user(@u3)
    check_index_disabled_for_user(@u4)
    check_index_disabled_for_user(@u5)
    check_index_disabled_for_user(@u6)
  end

  test 'admins index page is accessible to regular admins' do
    login_as(@a4, scope: :admin)
    check_index_enabled
  end

  test 'admins index page is accessible to super admins' do
    login_as(@a1, scope: :admin)
    check_index_enabled
  end
end
