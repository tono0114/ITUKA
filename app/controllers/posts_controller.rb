class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

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
    @favorite = Favorite.new
    @post_comments = @post.post_comments
    @post_comment = PostComment.new
  end

  def delete_confirm
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(@post.user.id)
  end

  def search
    if params[:keyword].present?
      @posts = Post.where('title LIKE ?', "%#{params[:keyword]}%").or(Post.where('country LIKE ?', "%#{params[:keyword]}%")).page(params[:page]).per(28)
      @keyword = params[:keyword]
    else
      @posts = Post.all.page(params[:page]).per(28)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :image_id, :country, :text)
  end

end
