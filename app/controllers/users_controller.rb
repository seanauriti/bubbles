class UsersController < ApplicationController

  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def edit  
    @user = User.find(current_user)
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:notice] = "Your profile has been updated"
    redirect_to bubbles_path
  end

end
