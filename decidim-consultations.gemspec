# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/consultations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-consultations"
  s.summary = "Extends Decidim adding a first level public consultation feature"
  s.description = s.summary
  s.version = Decidim::Consultations::VERSION
  s.authors = ["Juan Salvador Perez Garcia"]
  s.email = ["jsperezg@gmail.com"]
  s.license = "AGPLv3"
  s.homepage = "https://github.com/AjuntamentdeBarcelona/decidim"
  s.required_ruby_version = ">= 2.3.1"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin"
  s.add_dependency "decidim-comments"
  s.add_dependency "decidim-core", "~> #{s.version}"
  s.add_dependency "rails", "~> 5.1"

  s.add_development_dependency "decidim-dev", "~> #{s.version}"
end
