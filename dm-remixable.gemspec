# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-remixable}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Gamsjaeger (snusnu)"]
  s.date = %q{2009-07-16}
  s.email = %q{gamsnjaga@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "lib/dm-remixable.rb",
     "lib/dm-remixable/remixable.rb",
     "lib/dm-remixable/support.rb",
     "lib/dm-remixable/version.rb",
     "spec/fixtures/addressable.rb",
     "spec/fixtures/linkable.rb",
     "spec/fixtures/person.rb",
     "spec/integration/remixable_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/snusnu/dm-remixable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A rewrite of dm-is-remixable that tries to feel more dm'ish and adds desired behavior}
  s.test_files = [
    "spec/fixtures/addressable.rb",
     "spec/fixtures/linkable.rb",
     "spec/fixtures/person.rb",
     "spec/integration/remixable_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.0"])
  end
end
