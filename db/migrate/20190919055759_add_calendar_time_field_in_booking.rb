class AddCalendarTimeFieldInBooking < ActiveRecord::Migration[5.1]
  def change
    add_column  :bookings, :calendar_time_id, :integer, index: true
  end
end
