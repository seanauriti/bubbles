module BubblesHelper  
  
  include SyntaxFormatting 
        
  def link_to_aim(user)
    render :partial => 'aim_link', :locals => { :user => user }
  end
  
  def format_bubble(body)
    auto_link(format_syntax(body).gsub("\n","<br/>"))
  end

  
end
