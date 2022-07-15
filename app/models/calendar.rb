class Calendar < ApplicationRecord
  enum status: %i[Available Not_Available]
  validates :day, presence: true
  belongs_to :venue

  has_many :calendar_times

  accepts_nested_attributes_for :calendar_times, reject_if: :all_blank, allow_destroy: true

end
