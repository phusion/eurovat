require File.expand_path('lib/eurovat/version')

Gem::Specification.new do |s|
	s.name = "eurovat"
	s.version = Eurovat::VERSION_STRING
	s.summary = "European Union VAT number utilities"
	s.email = "software-signing@phusion.nl"
	s.homepage = "https://github.com/phusion/eurovat"
	s.description = "A utility library for dealing with European Union VAT numbers"
	s.authors = ["Hongli Lai"]
	
	s.files = Dir[
		"README.markdown",
		"LICENSE.txt",
		"lib/**/*",
		"test/*"
	]
end
