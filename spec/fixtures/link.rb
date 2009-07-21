class Link

  include DataMapper::Resource

  property :id,  Serial
  property :uri, URI

end
