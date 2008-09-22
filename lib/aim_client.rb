require 'net/toc'

class AimClient
  
  def initialize
    @client = Net::TOC.new("aibubblesbot", "listerinebot!")
    @client.connect
    
    @client.on_im do |msg, buddy|
      response = Net::HTTP.post_form(URI.parse('http://bubbles.alexanderinteractive.com/bots'), 
                                    {'aim' => buddy, 'message' => msg})
                                    
      #buddy.send_im("You just posted the following to bubbles: #{message}")
    end
  end
  
  def send_aim(screen_name, message)
    @client
    buddy = @client.buddy_list.buddy_named(screen_name)
    buddy.send_im "#{message}"
  end
  
end
    