class GonesController < ApplicationController
  def index
    @gone_festivals = current_user.gone_festivals
  end
  
  def create
    gone = Gone.new
    gone.user_id = current_user.id
    gone.festival_id = params[:festival_id]

    if gone.save
      redirect_to festivals_path, success: '行った！'
    else
      redirect_to festivals_path, danger: '登録に失敗しました'
    end
  end
  
  def destroy
    @gone = Gone.find_by(user_id: current_user.id, festival_id: params[:festival_id])
    @gone.destroy
    redirect_to festivals_path, success: 'お気に入りを取り消しました'
  end
end
