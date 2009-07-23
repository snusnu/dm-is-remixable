class PhoneNumber

  include DataMapper::Resource

  property :id,     Serial
  property :number, String

  belongs_to :person_address

end
