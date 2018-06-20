# -*- encoding: utf-8 -*-
# stub: minitest-spec-rails 5.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "minitest-spec-rails".freeze
  s.version = "5.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ken Collins".freeze]
  s.date = "2016-06-15"
  s.description = "The minitest-spec-rails gem makes it easy to use the MiniTest::Spec DSL within your existing Rails 3 or 4 test suite.".freeze
  s.email = ["ken@metaskills.net".freeze]
  s.homepage = "http://github.com/metaskills/minitest-spec-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Make Rails Use MiniTest::Spec!".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_runtime_dependency(%q<rails>.freeze, [">= 4.1"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<rails>.freeze, [">= 4.1"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<rails>.freeze, [">= 4.1"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
