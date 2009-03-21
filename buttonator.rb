require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/haml/lib/haml'
require 'RMagick'

include Magick

class Button
  def self.create(text)
    canvas = Image.new(200, 50)
    type = Draw.new
    type.fill = 'black'
    type.gravity = CenterGravity
    type.font = File.join(File.dirname(__FILE__), 'data/calibrib.ttf')
    type.pointsize = 30
    type.annotate(canvas, 0,0,0,0, text)
    canvas.write(File.join(File.dirname(__FILE__), 'public/button.png'))
  end
end


get "/" do
  haml :index
end

post "/create" do
  Button.create params[:text] unless params[:text] == ''
  redirect "/"
end
