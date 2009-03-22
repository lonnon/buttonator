require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/haml/lib/haml'
require 'RMagick'

include Magick

ROOT   = File.dirname(__FILE__)
FONTS  = File.join(ROOT, 'fonts')
PUBLIC = File.join(ROOT, 'public')

class Button
  def self.create(text, font)
    canvas = Image.new(200, 50)
    type = Draw.new
    type.fill = 'black'
    type.gravity = CenterGravity
    type.font = font
    type.pointsize = 30
    type.annotate(canvas, 0,0,0,0, text)
    canvas.write(File.join(PUBLIC, 'button.png'))
  end
end


helpers do
  def font_selection
    fonts = Dir["#{FONTS}/*"].collect do |file|
      radio = "<input type='radio' name='font' value='#{file}' />"
      radio += File.basename(file, ".ttf")
      radio += "<br />"
    end
    fonts[0].gsub!("' />", "' checked='checked' />")
    fonts
  end
end


get "/" do
  @fonts = font_selection
  haml :index
end

post "/create" do
  Button.create(params[:text], params[:font]) unless params[:text] == ''
  redirect "/"
end
