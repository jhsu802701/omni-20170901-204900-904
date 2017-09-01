#
class UsersController < ApplicationController
  # BEGIN: before_action section
  before_action :may_show_user, only: [:show]
  before_action :may_index_user, only: [:index]
  before_action :may_destroy_user, only: [:destroy]
  # END: before_action section

  # BEGIN: ACTION SECTION
  def show
    @user = User.find(params[:id])
  end

  # BEGIN: index
  # rubocop:disable Metrics/AbcSize
  def index
    @search = User.search(params[:q].presence)
    @users = @search.result.paginate(page: params[:page])
    # NOTE: The following line specifies the sort order.
    # This is reflected in the default sort criteria shown.
    # The user is free to remove these default criteria.
    @search.sorts = 'last_name asc' if @search.sorts.empty?
    @search.build_condition if @search.conditions.empty?
    @search.build_sort if @search.sorts.empty?
    @users = @search.result
    @users = @users.order('last_name').page(params[:page])
  end
  # rubocop:enable Metrics/AbcSize
  # END: index

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to(users_path)
  end
  # END: ACTION SECTION

  private

  # BEGIN: private section
  def admin_or_correct_user
    current_user == User.find(params[:id]) || admin_signed_in?
  end
  helper_method :admin_or_correct_user

  def may_show_user
    return redirect_to(root_path) unless admin_or_correct_user
  end
  helper_method :may_show_user

  def may_index_user
    return redirect_to(root_path) unless admin_signed_in?
  end
  helper_method :may_index_user

  def may_destroy_user
    return redirect_to(root_path) unless admin_signed_in?
  end
  helper_method :may_destroy_user
  # END: private section
end
