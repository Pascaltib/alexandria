class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :batch
  validates :user_id, presence: true, uniqueness: { scope: :batch_id }
end
