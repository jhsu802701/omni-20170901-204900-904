#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # rubocop:disable Lint/UselessAssignment
    # rubocop:disable Style/SymbolArray
    added_attrs = [:username, :email, :password, :password_confirmation,
                   :remember_me]
    # rubocop:enable Style/SymbolArray
    # rubocop:enable Lint/UselessAssignment
  end
end
