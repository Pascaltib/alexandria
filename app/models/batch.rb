class Batch < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :costs
  validates :name, presence: true
  validates :tuition_cost, presence: true

  include PgSearch::Model
  pg_search_scope :search_by,
    against: [ :first_name, :last_name, :email],
    using: {
      tsearch: { prefix: true } # this will return some....
    }
end
