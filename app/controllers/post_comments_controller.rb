class PostCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(comment_params)
    @post_comment.post_id = @post.id
    if @post_comment.save
      redirect_to request.referer
    else
      redirect_to post_path(@post.id)
      flash[:no_comment] = "※コメントを入力してください。"
    end
  end

  def destroy
    PostComment.find(params[:post_id]).destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:post_comment).permit(:comment)
  end

end
