class RelationshipsController < ApplicationController

  def follow
    current_user.follow(params[:id])
    redirect_to request.referer
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page])
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page])
  end

end
