class FestivalsController < ApplicationController
  def new
    @festival = Festival.new
  end
  
  def create
    @festival = Festival.new(festival_params)
    
    if @festival.save
      redirect_to festival_path(:id), success: '投稿に成功しました'
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new
    end
  end
  
  def index
    @festivals = Festival.all.includes(:gone_users)
    @festivals = Festival.all.includes(:wantgo_users)
  end
  
  def show
    @festival = Festival.find(params[:id])
    @festival_topics = @festival.topics.order(created_at: :desc)
    @comment = Comment.new
  end
  
  def comment
    @comment = Comment.new(body: params[:body], topic_id: params[:topic_id], user_id: params[:user_id])
    @comment.save
    redirect_to topics_path
  end
  
  private
  def festival_params
    params.require(:festival).permit(:event, :place, :ditail, :logo, :homepage)
  end
end
