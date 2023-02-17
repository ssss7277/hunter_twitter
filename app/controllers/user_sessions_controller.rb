class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new
    @email = params[:email]
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:notice] = "ログインしました"
      redirect_to posts_path
    else
      flash[:alert] = "メールアドレス,またはパスワードが間違っています。"
      redirect_to action: :new, params:{'email'  => params[:email]}
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
end
