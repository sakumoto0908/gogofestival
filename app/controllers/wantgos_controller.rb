class WantgosController < ApplicationController
  def index
    @wantgo_festivals = current_user.wantgo_festivals
  end
  
  def create
    wantgo = Wantgo.new
    wantgo.user_id = current_user.id
    wantgo.festival_id = params[:festival_id]
  
    if wantgo.save
      redirect_to festivals_path, success: '行きたい！'
    else
      redirect_to festivals_path, danger: '登録に失敗しました'
    end
  end
  
  def destroy
    @wantgo = Wantgo.find_by(user_id: current_user.id, festival_id: params[:festival_id])
    @wantgo.destroy
    redirect_to festivals_path, success: '行きたい！を取り消しました'
  end
end
