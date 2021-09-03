class UsersController < ApplicationController

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(9)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def unsubscribe
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to top_path
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

  def user_params
    params.require(:user).permit(:image_id, :name, :email, :introduction)
  end

end
