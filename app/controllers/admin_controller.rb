class AdminController < ApplicationController
  def users
    @users = User.all 
  end

  def delete_user
    id = params[:id]

    if current_user and id == current_user.id.to_s
      flash[:error] = "Delete User: You cannot delete yourself."
    else 
      user = User.find_by_id(id)
      
      if user.nil?
        flash[:error] = "Delete User: User with id #{id} doesn't exist."
      else
        user.destroy
        flash[:notice] = "Delete User: User #{user.username} deleted from database."
      end
    end
    
    @users = User.all
    render 'users'
  end
end
