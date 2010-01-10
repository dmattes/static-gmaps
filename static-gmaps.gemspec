Gem::Specification.new do |s|
  s.name = %q{static-gmaps}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Mattes"]
  s.date = %q{2009-02-19}
  s.description = %q{== DESCRIPTION:  Provides an interface to the Google Static Maps API. Original Version from John Wulff, modified by Daniel Mattes
  == FEATURES/PROBLEMS:  * Provides an interface to the Google Static Maps API.}
  s.email = %q{daniel.mattes@gmx.de}
  s.extra_rdoc_files = ["History.txt", "LICENSE.txt", "Manifest.txt", "readme.txt"]
  s.files = ["History.txt", "LICENSE.txt", "Manifest.txt", "readme.txt", "Rakefile", "lib/static_gmaps.rb", "spec/static_gmaps_spec.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "readme.txt"]
  s.homepage = 'http://github.com/dmattes/static-gmaps/'
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{static-gmaps}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Provides an interface to the Google Static Maps API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
