class Country

  include DataMapper::Resource

  property :id,   Serial
  property :name, String

  has n, :person_addresses

end
