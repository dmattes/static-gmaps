# The MIT License
# 
# Copyright (c) 2008 John Wulff <johnwulff@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'net/http'

module StaticGmaps 
  @@version = '0.0.4' 
  
  #map  
  @@maximum_url_size = 1978
  @@maximum_markers  = 50
  @@default_center   = [ 0, 0 ]
  @@default_zoom     = 1
  @@default_size     = [ 500, 400 ]
  @@default_map_type = :roadmap
  @@default_key      = 'ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA'
  

  
  #marker
  @@default_latitude        = nil
  @@default_longitude       = nil
  @@default_color           = nil
  @@default_alpha_character = nil
  @@valid_colors            = [ :red, :green, :blue ]
  @@valid_alpha_characters  = [ :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m, :n, :o, :p, :q, :r, :s, :t, :u, :v, :w, :x, :y, :z ]    
  
  [:version, :maximum_url_size, :maximum_markers, :default_center, :default_zoom, :default_size, :default_map_type, :default_key,
  :default_latitude, :default_longitude, :default_color, :default_alpha_character, :valid_colors, :valid_alpha_characters].each do |sym|
    class_eval <<-EOS
      def self.#{sym}
        @@#{sym}
      end

      def self.#{sym}=(obj)
        @@#{sym} = obj
      end
    EOS
  end  
      
  class Map


    attr_accessor :center,
                  :zoom,
                  :size,
                  :map_type,
                  :key,
                  :markers

    def initialize(options = {})
      self.center   = options[:center]
      self.zoom     = options[:zoom]     || StaticGmaps::default_zoom
      self.size     = options[:size]     || StaticGmaps::default_size
      self.map_type = options[:map_type] || StaticGmaps::default_map_type
      self.key      = options[:key]      || StaticGmaps::default_key
      self.markers  = options[:markers]  || [ ]
    end

    def width
      size[0]
    end

    def height
      size[1]
    end

    # http://code.google.com/apis/maps/documentation/staticmaps/index.html#URL_Parameters
    def url
      raise MissingArgument.new("Size must be set before a url can be generated for Map.") if !size || !size[0] || !size[1]
      raise MissingArgument.new("Key must be set before a url can be generated for Map.") if !key
      
      if(!self.center && !(markers && markers.size >= 1))
        self.center = StaticGmaps::default_center
      end
      
      if !(markers && markers.size >= 1)
        raise MissingArgument.new("Center must be set before a url can be generated for Map (or multiple markers can be specified).") if !center
        raise MissingArgument.new("Zoom must be set before a url can be generated for Map (or multiple markers can be specified).") if !zoom
      end
      raise "Google will not display more than #{StaticGmaps::maximum_markers} markers." if markers && markers.size > StaticGmaps::maximum_markers
      parameters = {}
      parameters[:size]     = "#{size[0]}x#{size[1]}"
      parameters[:key]      = "#{key}"
      parameters[:map_type] = "#{map_type}"               if map_type
      parameters[:center]   = "#{center[0]},#{center[1]}" if center
      parameters[:zoom]     = "#{zoom}"                   if zoom
      parameters[:markers]  = "#{markers_url_fragment}"   if markers_url_fragment
      parameters = parameters.to_a.sort { |a, b| a[0].to_s <=> b[0].to_s }
      parameters = parameters.collect { |parameter| "#{parameter[0]}=#{parameter[1]}" }
      parameters = parameters.join '&'
      x = "http://maps.google.com/staticmap?#{parameters}"
      raise "Google doesn't like the url to be longer than #{StaticGmaps::maximum_url_size} characters.  Try fewer or less precise markers." if x.size > StaticGmaps::maximum_url_size
      return x
    end  
    
    def markers_url_fragment
      if markers && markers.any?
        return markers.collect{|marker| marker.url_fragment }.join('|')
      else
        return nil
      end
    end

    def to_blob
      fetch
      return @blob
    end

    private
      def fetch
        if !@last_fetched_url || @last_fetched_url != url || !@blob
          uri = URI.parse url
          request = Net::HTTP::Get.new uri.path
          response = Net::HTTP.start(uri.host, uri.port) { |http| http.request request }
          @blob = response.body
          @last_fetched_url = url
        end
      end
  end

  # http://code.google.com/apis/maps/documentation/staticmaps/index.html#Markers
  class Marker
    
    attr_accessor :latitude,
                  :longitude,
                  :color,
                  :alpha_character
    
    def initialize(options = {})
      self.latitude        = options[:latitude]        || StaticGmaps::default_latitude
      self.longitude       = options[:longitude]       || StaticGmaps::default_longitude
      self.color           = options[:color]           || StaticGmaps::default_color
      self.alpha_character = options[:alpha_character] || StaticGmaps::default_alpha_character
    end
    
    def color=(value)
      if value
        value = value.to_s.downcase.to_sym
        if !StaticGmaps::valid_colors.include?(value)
          raise ArgumentError.new("#{value} is not a supported color.  Supported colors are #{StaticGmaps::valid_colors.join(', ')}.")
        end
      end
      @color = value
    end
    
    def alpha_character=(value)
      if value
        value = value.to_s.downcase.to_sym
        if !StaticGmaps::valid_alpha_characters.include?(value)
          raise ArgumentError.new("#{value} is not a supported alpha_character.  Supported colors are #{StaticGmaps::valid_alpha_characters.join(', ')}.")
        end
      end
      @alpha_character = value
    end
    
    def url_fragment
      raise MissingArgument.new("Latitude must be set before a url_fragment can be generated for Marker.") if !latitude
      raise MissingArgument.new("Longitude must be set before a url_fragment can be generated for Marker.") if !longitude
      x  = "#{latitude},#{longitude}"
      x += ",#{color}" if color
      x += "#{alpha_character}" if alpha_character
      return x
    end
  end
end