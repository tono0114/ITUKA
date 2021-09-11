class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_follow, only: [:followings, :followers]

  def follow
    current_user.follow(params[:id])
    redirect_to request.referer
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_to request.referer
  end

  def followings
    @users = @user.following_user.page(params[:page]).per(16)
  end

  def followers
    @users = @user.follower_user.page(params[:page]).per(16)
  end

  private

  def set_follow
    @user = User.find(params[:id])
  end

end
