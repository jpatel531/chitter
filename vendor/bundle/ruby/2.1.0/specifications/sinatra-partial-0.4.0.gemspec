# -*- encoding: utf-8 -*-
# stub: sinatra-partial 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra-partial"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chris Schneider", "Sam Elliott", "Iain Barnett"]
  s.date = "2012-12-10"
  s.description = "Just the partials helper in a gem. That is all."
  s.email = ["iainspeed@gmail.com"]
  s.homepage = "https://github.com/yb66/Sinatra-Partial"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "A sinatra extension for render partials."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
