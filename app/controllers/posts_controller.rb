class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post.id)
  end

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def delete_confirm
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :image_id, :country, :text, :user_id)
  end

end
