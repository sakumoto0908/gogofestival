class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    #binding.pry
    @user = User.new(name: params[:user][:name], email: params[:user][:email])
    if @user.save
      flash[:info] = '登録が完了しました'
      redirect_to root_path
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new
    end
  end
end