class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]

  def create
    @favorite = current_user.favorites.create(post_id: params[:post_id])
  end

  def destroy
    @favorite = current_user.favorites.find_by(post_id: params[:post_id]).destroy
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

end
