# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_name              :string
#  first_name             :string
#  username               :string
#  super                  :boolean
#

require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  def setup
    @admin = Admin.new(last_name: 'Bond', first_name: 'James',
                       username: 'jbond007', email: '007@example.com',
                       password: 'bond_james_bond',
                       password_confirmation: 'bond_james_bond',
                       confirmed_at: Time.now)
  end

  test 'should be valid' do
    assert @admin.valid?
  end

  test 'email should be present' do
    @admin.email = '     '
    assert_not @admin.valid?
  end

  test 'email should not be too long' do
    @admin.email = 'a' * 244 + '@example.com'
    assert_not @admin.valid?
    @admin.email = 'a' * 243 + '@example.com'
    assert @admin.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[admin@example.com ADMIN@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @admin.email = valid_address
      assert @admin.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[admin@example,com admin_at_foo.org
                           admin.name@example. foo@bar_baz.com
                           foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @admin.email = invalid_address
      assert_not @admin.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    duplicate_admin = @admin.dup
    duplicate_admin.email = @admin.email.upcase
    @admin.save
    assert_not duplicate_admin.valid?
  end

  test 'username should be unique' do
    # duplicate_admin: different email; same username but uppercase
    duplicate_admin = @admin.dup
    duplicate_admin.email = '008@example.com'
    duplicate_admin.username = @admin.username.upcase
    @admin.save
    assert_not duplicate_admin.valid?
    # duplicate_admin: different email; different username
    duplicate_admin = @admin.dup
    duplicate_admin.email = '008@example.com'
    duplicate_admin.username = 'jbond008'
    @admin.save
    assert duplicate_admin.valid?
  end

  test 'username should be present' do
    @admin.username = 'jbond_007'
    assert @admin.valid?
    @admin.username = 'j'
    assert @admin.valid?
    @admin.username = '     '
    assert_not @admin.valid?
  end

  test 'username should not have @ symbol in it' do
    @admin.username = 'jbond007@'
    assert_not @admin.valid?
    @admin.username = '@jbond007'
    assert_not @admin.valid?
    @admin.username = 'jbond007@example.com'
    assert_not @admin.valid?
  end

  test 'username should be no longer than 255 characters' do
    @admin.username = 'a' * 256
    assert_not @admin.valid?
    @admin.username = 'a' * 255
    assert @admin.valid?
  end

  test 'first name should be present and no longer than 50 characters' do
    @admin.first_name = '     '
    assert_not @admin.valid?
    @admin.first_name = 'A' + 'a' * 50
    assert_not @admin.valid?
  end

  test 'last name should be present and no longer than 50 characters' do
    @admin.last_name = '     '
    assert_not @admin.valid?
    @admin.last_name = 'A' + 'a' * 50
    assert_not @admin.valid?
  end

  test 'password should have a minimum length of 10 characters' do
    @admin.password = @admin.password_confirmation = 'a' * 9
    assert_not @admin.valid?
    @admin.password = @admin.password_confirmation = 'a' * 10
    assert @admin.valid?
  end
end
