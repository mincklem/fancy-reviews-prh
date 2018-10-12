# -*- encoding: utf-8 -*-
# stub: highscore 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "highscore".freeze
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dominik Liebler".freeze]
  s.date = "2016-08-23"
  s.description = "Find and rank keywords in text.".freeze
  s.email = "liebler.dominik@googlemail.com".freeze
  s.executables = ["highscore".freeze]
  s.extra_rdoc_files = ["History.txt".freeze, "lib/blacklist.txt".freeze]
  s.files = ["History.txt".freeze, "bin/highscore".freeze, "lib/blacklist.txt".freeze]
  s.homepage = "http://domnikl.github.com/highscore".freeze
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.rubyforge_project = "highscore".freeze
  s.rubygems_version = "2.5.2.3".freeze
  s.summary = "Easily find and rank keywords in long texts.".freeze

  s.installed_by_version = "2.5.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0.6.4"])
      s.add_runtime_dependency(%q<whatlanguage>.freeze, [">= 1.0.0"])
    else
      s.add_dependency(%q<simplecov>.freeze, [">= 0.6.4"])
      s.add_dependency(%q<whatlanguage>.freeze, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<simplecov>.freeze, [">= 0.6.4"])
    s.add_dependency(%q<whatlanguage>.freeze, [">= 1.0.0"])
  end
end
