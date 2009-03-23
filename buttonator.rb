require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/haml/lib/haml'
require 'RMagick'

ROOT   = File.dirname(__FILE__)
FONTS  = File.join(ROOT, 'fonts')
PUBLIC = File.join(ROOT, 'public')

module Buttonator
  class Button
    def self.make(text, options = {})
      width     = options[:width] || 200
      height    = options[:height] || 50
      fill      = options[:fill] || 'black'
      gravity   = options[:gravity] || Magick::CenterGravity
      font      = options[:font] || Buttonator::Font.new(File.join(FONTS, 'calibrib.ttf'))
      pointsize = options[:pointsize] || 30
      outfile   = options[:outfile] || File.join(PUBLIC, 'button.png')
      
      canvas = Magick::Image.new(width, height)
      type = Magick::Draw.new
      type.fill = fill
      type.gravity = gravity
      type.font = font.filename
      type.pointsize = pointsize
      type.annotate(canvas, 0,0,0,0, text)
      canvas.write(outfile)
    end
  end

  class Font
    def initialize(file)
      @filename = file
    end
    
    def filename
      @filename
    end
    
    def name
      File.basename(@filename, ".ttf")
    end
    
    def image_name
      "font_#{name}.png"
    end
    
    def sample_image
      unless File.exist?(File.join(PUBLIC, image_name))
        Buttonator::Button.make("hamburgefontsiv",
                                :outfile => File.join(PUBLIC, image_name),
                                :width => 150, :height => 20,
                                :font => self, :pointsize => 14,
                                :gravity => Magick::SouthWestGravity)
      end
    end
  end
end

helpers do
  def get_fonts
    fonts = []
    Dir["#{FONTS}/*"].each do |file|
      fonts.push(Buttonator::Font.new(file))
    end
    fonts
  end
  
  def make_sample_images(fonts)
    fonts.each do |font|
      font.sample_image
    end
  end
end


get "/" do
  @fonts = get_fonts
  make_sample_images(@fonts)
  @first_font = @fonts.shift
  haml :index
end

post "/create" do
  unless params[:text] == ''
    Buttonator::Button.make(params[:text],
                                   :font => Buttonator::Font.new(params[:font]))
  end
  redirect "/"
end
