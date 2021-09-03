class PostCommentsController < ApplicationController

  def create
    @post = Post.find_by(params[:post_id])
    @post_comment = current_user.post_comments.new(comment_params)
    @post_comment.post_id = @post.id
    @post_comment.save
    redirect_to request.referer
  end

  def destroy
    PostComment.find_by(params[:id]).destroy
    redirect_to request.referer
  end

  def comment_params
    params.require(:post_comment).permit(:comment)
  end

end
