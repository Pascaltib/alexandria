class Batch < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :costs
end
