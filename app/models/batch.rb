class Batch < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :costs
  validates :name, presence: true
  validates :tuition_cost, presence: true
end
