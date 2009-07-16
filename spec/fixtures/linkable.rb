module Linkable
  extend DataMapper::Remixable
  remixable :linkable do
    property :id,  Serial
    property :uri, URI
  end
end