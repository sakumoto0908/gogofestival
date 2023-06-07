class ProfilesController < ApplicationController
 before_action :set_user
 def show; end

 def edit; end

 def update
   if @user.update(user_params)
     redirect_to profile_path, success: 'Profile was successfully updated.'
   else
     flash.now[:danger] = 'Failed to update the profile.'
     render :edit
   end
 end

 private

 #avatarカラムを持たせる
 def user_params
   params.require(:user).permit(:email, :name, :avatar)
 end
  
 private 
 def set_user
   @user = User.find(current_user.id)
 end
end