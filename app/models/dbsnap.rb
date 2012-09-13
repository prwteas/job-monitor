class Dbsnap
  include Mongoid::Document
  include Mongoid::Timestamps

  field :open, type: Integer
  field :closed, type: Integer


end
