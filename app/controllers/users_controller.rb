class UsersController < ApplicationController
  def my_portfolio
    @stocks = current_user.stocks
  end

  def my_friends 
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends
        respond_to do |format|
          format.js {render partial: 'users/friend_results'}
        end
      else
        flash.now[:notice] = "No user found with the entered credentials"
        respond_to do |format|
          format.js {render partial: 'users/friend_results'}
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a name or an email to search"
        format.js { render partial: 'users/friend_results' }
      end
    end
  end
end
