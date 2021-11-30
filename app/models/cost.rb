class Cost < ApplicationRecord
  belongs_to :batch
  validates :name, presence: true
  validates :amount, presence: true
  validates :kind, presence: true
  validates :recurring, presence: true
  validate :recurring_with_fixed

  private

  def recurring_with_fixed
    if recurring != "One Time" && kind == "Variable"
      errors.add(:recurring, " - Variable costs must be one time")
    end
  end
end
