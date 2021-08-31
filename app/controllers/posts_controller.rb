class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post.id)
  end

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all.page(params[:page]).per(28)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def delete_confirm
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :image_id, :country, :text)
  end

end
