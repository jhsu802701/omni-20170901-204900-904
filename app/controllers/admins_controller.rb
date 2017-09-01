#
class AdminsController < ApplicationController
  # BEGIN: before_action section
  before_action :may_show_admin, only: [:show]
  before_action :may_index_admin, only: [:index]
  before_action :may_destroy_admin, only: [:destroy]
  # END: before_action section

  # BEGIN: ACTION SECTION
  def show
    @admin = Admin.find(params[:id])
  end

  # BEGIN: index
  def index
    @admins = Admin.paginate(page: params[:page])
  end
  # END: index

  def destroy
    Admin.find(params[:id]).destroy
    flash[:success] = 'Admin deleted'
    redirect_to(admins_path)
  end
  # END: ACTION SECTION

  private

  # BEGIN: private section
  def may_show_admin
    return redirect_to(root_path) unless admin_signed_in? == true
  end
  helper_method :may_show_admin

  def may_index_admin
    may_show_admin
  end
  helper_method :may_index_admin

  def no_destroy
    ta = Admin.find(params[:id]) # Target admin
    ca = current_admin
    # Do not delete if:
    # 1.  current_admin is nil OR
    # 2.  Attempting to delete self OR
    # 3.  Not a super admin OR
    # 4.  Target is super admin
    ca.nil? || ca == ta || ca.super != true || ta.super == true
  end

  def may_destroy_admin
    return redirect_to(root_path) if no_destroy == true
  end
  helper_method :may_destroy_admin
  # END: private section
end
