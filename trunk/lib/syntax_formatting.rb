require 'syntax/convertors/html' 
require 'syntaxi'
Syntaxi::line_number_method = 'floating'

module SyntaxFormatting
  
  def format_syntax(body)
    Syntaxi.new(body).process
  end
  
  def delimited(body)
    # logic to determine what kind of code is in the body
    "[code lang='ruby']#{body}[/code]"
  end

end
  