require 'net/toc'

module AimNotifications
  
  $client = Net::TOC.new("aibubblesbot", "listerinebot!")
  
  def send_aim(screen_name, message)
    $client.connect
    buddy = $client.buddy_list.buddy_named(screen_name)
    buddy.send_im "#{message}"
  end
  
end
    