class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new home]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to home_path
    else
      flash[:alert] = "入力内容に誤りがあります"
      redirect_to action: :new
    end
  end

  def home
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
