# -*- encoding: utf-8 -*-
# stub: monkeylearn 3.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "monkeylearn".freeze
  s.version = "3.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Monkeylearn".freeze]
  s.date = "2018-07-30"
  s.description = "A simple client for the MonkeyLearn API".freeze
  s.email = ["hello@monkeylearn.com".freeze]
  s.homepage = "https://github.com/monkeylearn/monkeylearn-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Ruby client for the MonkeyLearn API".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>.freeze, ["<= 0.15.0", ">= 0.9.2"])
    else
      s.add_dependency(%q<faraday>.freeze, ["<= 0.15.0", ">= 0.9.2"])
    end
  else
    s.add_dependency(%q<faraday>.freeze, ["<= 0.15.0", ">= 0.9.2"])
  end
end
