class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new guest_login]

  def new
    @email = params[:email]
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      if @user.role == "admin"
        flash[:notice] = "管理者としてログインしました"
        redirect_to admin_users_path
      else
        flash[:notice] = "ログインしました"
        redirect_to posts_path
      end
    else
      flash[:alert] = "メールアドレス,またはパスワードが間違っています。"
      redirect_to action: :new, params:{'email'  => params[:email]}
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end

  def guest_login
    @guest_user = User.create(
      name: "ゲスト",
      email: SecureRandom.alphanumeric(10) + "@guest.com",
      password: "guestguest",
      password_confirmation: "guestguest",
      role: 2)
    auto_login(@guest_user)
    redirect_to posts_path, notice: 'ゲストとしてログインしました'
  end

private

def user_params
  params.require(:user).permit(:email, :password, :password_confirmation, :name, :role)
end
end

