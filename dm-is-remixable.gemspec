# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-remixable}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Gamsjaeger (snusnu)"]
  s.date = %q{2009-07-21}
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
     "VERSION",
     "dm-is-remixable.gemspec",
     "lib/dm-is-remixable.rb",
     "lib/dm-is-remixable/is/remixable.rb",
     "lib/dm-is-remixable/is/support.rb",
     "lib/dm-is-remixable/is/version.rb",
     "spec/fixtures/addressable.rb",
     "spec/fixtures/country.rb",
     "spec/fixtures/link.rb",
     "spec/fixtures/linkable.rb",
     "spec/fixtures/person.rb",
     "spec/fixtures/phone_number.rb",
     "spec/integration/remix_intermediate_spec.rb",
     "spec/integration/remix_target_spec.rb",
     "spec/shared/every_remixable_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/unit/remixable_spec.rb",
     "tasks/changelog.rb"
  ]
  s.homepage = %q{http://github.com/snusnu/dm-is-remixable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A rewrite of dm-is-remixable that tries to feel more dm'ish and adds desired behavior}
  s.test_files = [
    "spec/fixtures/addressable.rb",
     "spec/fixtures/country.rb",
     "spec/fixtures/link.rb",
     "spec/fixtures/linkable.rb",
     "spec/fixtures/person.rb",
     "spec/fixtures/phone_number.rb",
     "spec/integration/remix_intermediate_spec.rb",
     "spec/integration/remix_target_spec.rb",
     "spec/shared/every_remixable_spec.rb",
     "spec/spec_helper.rb",
     "spec/unit/remixable_spec.rb"
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
