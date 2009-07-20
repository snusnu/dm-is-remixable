class PhoneNumber

  include DataMapper::Resource

  property :id,     Serial
  property :number, String

end
