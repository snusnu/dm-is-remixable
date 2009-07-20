require 'pathname'
require 'rubygems'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-is-remixable' / 'is'

require dir / 'support'
require dir / 'remixable'

# activate the plugin
DataMapper::Model.append_extensions(DataMapper::Is::Remixable)
DataMapper::Model.append_extensions(DataMapper::Is::Remixable::Remixer)
DataMapper::Model.append_extensions(DataMapper::Is::Remixable::Support)
