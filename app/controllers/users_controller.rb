class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_normal_user, only: [:update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :unsubscribe, :destroy,]

  def index
    @users = User.all.page(params[:page]).per(16)
  end

  def show
    @posts = @user.posts.page(params[:page]).per(9)
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user.id), notice: "ユーザー情報を更新しました。"
  end

  def unsubscribe
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "退会処理が完了しました。"
  end

  def search
    if params[:keyword].present?
      @users = User.where('name LIKE ?', "%#{params[:keyword]}%").page(params[:page])
      @keyword = params[:keyword]
    else
      @users = User.all.page(params[:page])
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_normal_user
    if current_user.email == "guest@ituka.com"
      redirect_to posts_path, notice: "ゲストユーザーの更新・削除はできません。"
    end
  end

  def user_params
    params.require(:user).permit(:image_id, :name, :email, :introduction)
  end

end
