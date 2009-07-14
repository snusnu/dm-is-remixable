require 'pathname'

require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'common'
require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'remixable'
require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'remixee'
require Pathname(__FILE__).dirname.expand_path / 'dm-remixables' / 'remixer'

# activate the plugin
DataMapper::Model.append_extensions(DataMapper::Remixables)
