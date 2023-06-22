class TopicsController < ApplicationController
  def index
    @topics = Topic.all.includes(:favorite_users)
    @topic = Topic.new
    @comment = Comment.new
  end
  
  def new
    @festival_id = params[:festival_id]
    @topic = Topic.new
  end
  
  def create
    @festival = Festival.find(params[:topic][:festival_id].to_i)
    #@festival = Festival.find(params[:festival_id].to_i)
    @topic = current_user.topics.new(topic_params)
    @topic.festival_id = @festival.id
    @topic.user_id = current_user.id
    
    if @topic.save
      redirect_to festivals_path, success: '投稿しました'
    else
      flash.now[:danger] = "投稿できませんでした"
      render :new
    end
  end
  
  def destroy
    topic = Topic.find(params[:id])
    topic.destroy
  end
  
  def edit
  end
  
  def update
    topic = Topic.find(params[:id])
    topic.update(topic_params)
  end
  
  def show
  end
  
  def comment
    @comment = Comment.new(body: params[:body], topic_id: params[:topic_id], user_id: params[:user_id])
    @comment.save
    redirect_to topics_path
  end
  
  private
  def topic_params
    params.require(:topic).permit(:image, :body)
  end
end
