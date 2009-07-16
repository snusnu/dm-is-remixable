module Addressable
  extend DataMapper::Remixable
  remixable :addressable do
    property :id,     Serial
    property :street, String
    has n, :phone_numbers
  end
end