class FavoritesController < ApplicationController
  def index
    @favorite_topics = current_user.favorite_topics
    @gone_festivals = current_user.gone_festivals
    @wantgo_festivals = current_user.wantgo_festivals
  end
  
  def create
    favorite = Favorite.new
    favorite.user_id = current_user.id
    favorite.topic_id = params[:topic_id]
    
    if favorite.save
      redirect_to festivals_path(:id), success: 'お気に入りに登録しました'
    else
      redirect_to festivals_path, danger: "お気に入りに登録失敗しました"
    end
  end
  
  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    @favorite.destroy
    redirect_to festivals_path, success: 'お気に入りを取り消しました'
  end
end
