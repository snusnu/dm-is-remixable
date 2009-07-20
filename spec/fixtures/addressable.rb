module Addressable

  extend DataMapper::Model

  is :remixable

  property :id,      Serial
  property :address, String, :nullable => false

  belongs_to :country
  has n, :phone_numbers

end
