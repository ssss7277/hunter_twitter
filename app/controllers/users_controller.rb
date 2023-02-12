class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new
    @user = User.new
    @name = params[:name]
    @email = params[:email]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      session[:user_id]=@user.id
      redirect_to home_path
    else
      flash[:alert] = "入力内容に誤りがあります"
      redirect_to action: :new, params:{'name'  => params[:user][:name], 'email'  => params[:user][:email]}
    end
  end

  def home
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
