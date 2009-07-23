module Linkable

  extend DataMapper::Model

  is :remixable

  property :created_at, DateTime
  property :updated_at, DateTime

end
