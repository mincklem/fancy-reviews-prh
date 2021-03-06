# -*- encoding: utf-8 -*-
# stub: lda-ruby 0.3.9 ruby lib ext
# stub: ext/lda-ruby/extconf.rb

Gem::Specification.new do |s|
  s.name = "lda-ruby".freeze
  s.version = "0.3.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "ext".freeze]
  s.authors = ["David Blei".freeze, "Jason Adams".freeze, "Rio Akasaka".freeze]
  s.date = "2015-02-11"
  s.description = "Ruby port of Latent Dirichlet Allocation by David M. Blei. See http://www.cs.princeton.edu/~blei/lda-c/.".freeze
  s.email = "jasonmadams@gmail.com".freeze
  s.extensions = ["ext/lda-ruby/extconf.rb".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "ext/lda-ruby/extconf.rb".freeze]
  s.homepage = "http://github.com/ealdent/lda-ruby".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Ruby port of Latent Dirichlet Allocation by David M. Blei.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<shoulda>.freeze, [">= 0"])
    else
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
  end
end
