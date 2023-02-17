class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      session[:user_id]=@user.id
      redirect_to posts_path
    else
      flash[:alert] = "入力内容に誤りがあります"
      render :new
      # redirect_to action: :new, params:{'name'  => params[:name], 'email'  => params[:email], 'password'  => params[:password]}, 'password_confirmation'  => params[:password_confirmation]
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @post_favorites = Post.find(favorites)
  end

  def home
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
