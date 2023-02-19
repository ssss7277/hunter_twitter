class Admin::UsersController < ApplicationController
  before_action :require_admin_login

  def index
    @users = User.all.order("created_at ASC")
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

private
  def user_params
    params.require(:user).permit(:email, :name, :role)
  end
end
