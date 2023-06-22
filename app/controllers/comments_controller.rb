class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to root_url
    else
      render "topics/index"
    end
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end