class PostsController < ApplicationController
  before_action :ensure_correct_user, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    @post.save
    redirect_to posts_path
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
   end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to request.referer
    else
      redirect_to new_post_path
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def ensure_correct_user
    @post=Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice]="権限がありません"
      redirect_to posts_path
    end
  end

private
  def post_params
    params.require(:post).permit(:body)
  end
end