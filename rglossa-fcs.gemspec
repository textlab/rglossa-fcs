# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rglossa/fcs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rglossa-fcs"
  s.version     = Rglossa::Fcs::VERSION
  s.authors     = ["Anders Nøklestad"]
  s.email       = ["anders.noklestad@iln.uio.no"]
  s.homepage    = 'http://www.hf.uio.no/iln/english/about/organization/text-laboratory/'
  s.summary     = "Federated content search for Glossa"
  s.description = "CLARIN federated content search for rglossa, the Ruby on Rails version of the Glossa system for corpus search and results management"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.19"
  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"
  # s.add_dependency "jquery-rails"
  # s.add_dependency "rglossa"

  s.add_development_dependency "sqlite3"
end
