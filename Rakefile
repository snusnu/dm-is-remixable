require 'pathname'
require 'rubygems'
require 'rake'

GEM_NAME = 'dm-is-remixable'

ROOT = Pathname(__FILE__).dirname.expand_path
JRUBY = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name     = GEM_NAME
    gem.summary  = "A rewrite of dm-is-remixable that tries to feel more dm'ish and adds desired behavior"
    gem.email    = "gamsnjaga@gmail.com"
    gem.homepage = "http://github.com/snusnu/dm-is-remixable"
    gem.authors  = ["Martin Gamsjaeger (snusnu)"]
    gem.add_dependency('dm-core', '>= 0.10.0')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  gem 'rspec', '>=1.1.12'
  require 'spec'
  require 'spec/rake/spectask'

  task :default => [ :spec ]

  desc 'Run specifications'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
    t.spec_files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s).map { |f| f.to_s }

    begin
      gem 'rcov', '~>0.8'
      t.rcov = JRUBY ? false : (ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true)
      t.rcov_opts << '--exclude' << 'spec'
      t.rcov_opts << '--text-summary'
      t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
    rescue LoadError
      # rcov not installed
    end
  end
rescue LoadError
  # rspec not installed
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-localizable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# require all tasks below tasks
Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
