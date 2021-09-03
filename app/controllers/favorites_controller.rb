class FavoritesController < ApplicationController
  before_action :set_post, only: [:create, :destroy]

  def create
    @favorite = current_user.favorites.create(post_id: params[:post_id])
  end

  def destroy
    @favorite = Favorite.find_by(post_id: params[:post_id], user_id: current_user.id)
    @favorite.destroy
  end

  private

  def set_post
    @post = Post.find_by(params[:post_id])
  end

end
