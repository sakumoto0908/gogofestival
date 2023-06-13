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
    @festivals = Festival.all
  end
  
  def show
    @festival = festival_url(params[:id])
  end
  
  private
  def festival_params
    params.require(:festival).permit(:event, :place, :ditail, :logo, :homepage)
  end
end
