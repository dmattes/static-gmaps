= StaticGmaps

* http://static-gmaps.rubyforge.org/

== DESCRIPTION:

Provides an interface to the Google Static Maps API.
Original Version from John Wulff, modified by Daniel Mattes

== FEATURES/PROBLEMS:

* Provides an interface to the Google Static Maps API.

== SYNOPSIS:

  # In environment.rb or initializers you can set default values, for example
  StaticGmaps::default_size = [ 170, 200 ]

	# Get from http://code.google.com/apis/maps/signup.html
	GOOGLE_MAPS_API_KEY = ''

  map = StaticGmaps::Map.new :center   => [ 40.714728, -73.998672 ],
                             :zoom     => 5,
                             :size     => [ 500, 400 ],
                             :map_type => :roadmap,
                             :key      => GOOGLE_MAPS_API_KEY
  map.markers << StaticGmaps::Marker.new(:latitude => 40,
                                         :longitude => -73,
                                         :color => :blue,
                                         :alpha_character => :b)
  map.url => 'http://maps.google.com/staticmap?center=40.714728,-73.998672&key=GOOGLE_MAPS_API_KEY&map_type=roadmap&markers=40,-73,blueb&size=500x400&zoom=5'

== REQUIREMENTS:

* None.

== INSTALL:

* sudo gem install static-gmaps

== LICENSE:

(The MIT License)

Copyright (c) 2008 John Wulff <johnwulff@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
