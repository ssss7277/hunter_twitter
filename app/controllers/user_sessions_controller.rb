class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:notice] = "ログインしました"
      redirect_to home_path
    else
      flash[:alert] = "メールアドレス,またはパスワードが間違っています。"
      redirect_to action: :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
end
