class FriendshipsController < ApplicationController
  def create
    if Friendship.create(user_id: current_user.id, friend_id: params[:friend])
      redirect_to my_friends_path
    else
      flash[:alert] = "There has been some error in request"
      redirect_to my_friends_path
    end
  end

  def destroy
    Friendship.where(user_id: current_user.id, friend_id: params[:id]).first.destroy
    redirect_to my_friends_path
  end
end
