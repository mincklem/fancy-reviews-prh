# -*- encoding: utf-8 -*-
# stub: ruby_nlp 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby_nlp".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nathan Kleyn".freeze]
  s.date = "2013-09-14"
  s.description = "A simple NLP toolkit in pure Ruby. See http://github.com/nathankleyn/ruby_nlp for more information.".freeze
  s.email = "nathan@nathankleyn.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://github.com/nathankleyn/ruby_nlp".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "A simple NLP toolkit in pure Ruby.".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
  end
end
