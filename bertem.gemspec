# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bertem}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benjamin Black"]
  s.date = %q{2009-12-27}
  s.email = %q{b@b3k.us}
  s.files = [
    "Rakefile",
     "VERSION",
     "bertem.gemspec",
     "lib/bertem.rb",
     "lib/bertem/action.rb",
     "lib/bertem/bertrpc.rb"
  ]
  s.homepage = %q{http://github.com/b/bertem}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{BERTEM is a Ruby EventMachine BERT-RPC client library.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bertrpc>, [">= 1.1.2", "< 2.0.0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
    else
      s.add_dependency(%q<bertrpc>, [">= 1.1.2", "< 2.0.0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
    end
  else
    s.add_dependency(%q<bertrpc>, [">= 1.1.2", "< 2.0.0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
  end
end

