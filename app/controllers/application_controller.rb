class ApplicationController < ActionController::Base
  before_action :require_login

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_admin_login
    if @current_user.role != "admin"
      redirect_to posts_path, notice: "管理者権限がありません"
    end
  end

private
  def not_authenticated
    redirect_to login_path, danger: "ログインしてください"
  end
end
