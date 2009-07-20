module Linkable

  extend DataMapper::Model

  is :remixable

  property :id,  Serial
  property :uri, URI

end
