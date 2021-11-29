class Batch < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :costs
  validates :name, presence: true
  validates :tuition_cost, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
