class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :delete_confirm, :destroy]

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id), notice: "投稿しました。"
    else
      redirect_to new_post_path
      flash[:no_post] = "※Titleを入力してください。"
    end
  end

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all.page(params[:page]).per(28)
  end

  def show
    @user = @post.user
    @favorite = Favorite.new
    @post_comments = @post.post_comments
    @post_comment = PostComment.new
  end

  def edit
  end

  def update
    @post.update(post_params)
    redirect_to post_path(@post.id), notice: "投稿内容を更新しました。"
  end

  def delete_confirm
  end

  def destroy
    @post.destroy
    redirect_to user_path(@post.user.id), notice: "投稿を削除しました。"
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

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :image_id, :country, :text)
  end

end
