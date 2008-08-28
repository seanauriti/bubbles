require 'rubygems'
require 'net/http'
require 'net/toc'

class Bot
  def initialize
    client = Net::TOC.new("aibubblesbot", "listerinebot!") 
    client.connect
    client.on_im do |msg, buddy|
      response = Net::HTTP.post_form(URI.parse('http://bubbles.alexanderinteractive.com/bots'), 
                                    {'aim' => buddy, 'message' => msg})
      buddy.send_im("You just posted the following to bubbles: #{message}")
    end
    client.wait
  end
end

Bot.new
