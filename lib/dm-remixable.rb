require 'pathname'
require 'rubygems'
require 'dm-core'
require 'extlib/lazy_module'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-remixable'

require dir / 'support'
require dir / 'remixable'

# activate the plugin
DataMapper::Model.append_extensions(DataMapper::Remixable::Support)
DataMapper::Model.append_extensions(DataMapper::Remixable::Remixer)
