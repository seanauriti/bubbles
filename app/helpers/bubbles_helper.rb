module BubblesHelper  
  
  def link_to_aim(user)
    render :partial => 'aim_link', :locals => { :user => user }
  end
  
  
  
end
