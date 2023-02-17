class ApplicationController < ActionController::Base
  before_action :require_login

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

private
  def not_authenticated
    redirect_to login_path, danger: "ログインしてください"
  end
end
