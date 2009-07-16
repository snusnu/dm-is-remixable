require 'pathname'

require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'support'
require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'remixable'

# activate the plugin
DataMapper::Model.append_extensions(DataMapper::Remixable::Support)
DataMapper::Model.append_extensions(DataMapper::Remixable::Remixer)
