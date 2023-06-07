class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(3).reverse_order
  end
  
  def show
    @user = User.find(params[:id])
    @topics = @user.topics.page(params[:page]).reverse_order
  end
  
  def new
    @user = User.new
  end
  
  def create
    #binding.pry
    @user = User.new(user_params)
    if @user.save
      flash[:info] = '登録が完了しました'
      redirect_to root_path
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end