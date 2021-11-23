class Cost < ApplicationRecord
  belongs_to :batch
  validates :name, presence: true
  validates :amount, presence: true
end
