

class Location
  include Mongoid::Document
  field :city, type: String
  field :country, type: String
  field :lat, type: Float
  field :lng, type: Float

  index({ city: 1 }, { unique: true })



end
