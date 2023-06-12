class TopicsController < ApplicationController
  def index
    @topics = Topic.all.includes(:favorite_users)
    @topic = Topic.new
  end
  
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = current_user.topics.new(topic_params)
    
    if @topic.save
      redirect_to topics_path, success: '投稿しました'
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
  
  private
  def topic_params
    params.require(:topic).permit(:image, :body)
  end
end
