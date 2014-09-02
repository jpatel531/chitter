# -*- encoding: utf-8 -*-
# stub: cucumber-sinatra 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-sinatra"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bernd Ahlers"]
  s.date = "2012-04-01"
  s.description = "This little gem will help you to initialize a cucumber environment for a sinatra application. It will generate the required files from templates."
  s.email = "bernd@tuneafish.de"
  s.executables = ["cucumber-sinatra"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["LICENSE", "README.md", "bin/cucumber-sinatra"]
  s.homepage = "http://github.com/bernd/cucumber-sinatra"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "cucumber-sinatra"
  s.rubygems_version = "2.2.2"
  s.summary = "Initialize a cucumber environment for sinatra"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<templater>, [">= 1.0.0"])
    else
      s.add_dependency(%q<templater>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<templater>, [">= 1.0.0"])
  end
end
