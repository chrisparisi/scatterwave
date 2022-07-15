class CalendarTime < ApplicationRecord
  belongs_to :calendar
  has_one :booking

end
