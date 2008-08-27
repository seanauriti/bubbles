require 'rubygems'
require 'net/http'
require 'net/toc'

class Bot
  def initialize
    client = Net::TOC.new('aibubblesbot', 'listerine!') 
    client.connect
    client.on_im do |msg, buddy|
      response = Net::HTTP.post_form(URI.parse('http://bubbles.alexanderinteractive.com/bots'), 
                                    {'aim' => buddy, 'message' => msg})
      if response == Net::HTTPSuccess
        buddy.send_im("#{response.body}")
      end
    end
    client.wait
  end
end

Bot.new