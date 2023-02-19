class Admin::PostsController < ApplicationController
  before_action :admin_user

  def index
    @posts = Post.all.order("created_at ASC")
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_posts_path
    else
      flash[:notice]="入力内容に誤りがあります"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  private
  def admin_user
    unless current_user.role = "admin"
    redirect_to(root_path)
    end
  end
  private
  def post_params
    params.require(:post).permit(:body)
  end
end
