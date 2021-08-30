class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
  end

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
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
