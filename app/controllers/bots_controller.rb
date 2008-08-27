class BotsController < ApplicationController
  
  def create
    user = User.find_by_aim(params[:aim])
    user.bubbles.create :body => params[:message]
  end

end

