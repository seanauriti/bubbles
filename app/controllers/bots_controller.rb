class BotsController < ApplicationController
  
  def create
    user = User.find_by_aim(params[:aim])
    if user.bubbles.create :body => params[:message]
      render :text => "Thanks, #{user.login}.  Your bubble was successfully posted."
    end
  end

end

