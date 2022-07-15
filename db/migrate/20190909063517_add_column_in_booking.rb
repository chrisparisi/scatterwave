class AddColumnInBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :is_paid, :boolean, default: false
    add_column :bookings, :paid_at, :datetime, default: nil
    add_column :bookings, :request_count, :integer, default: 0
    add_column :bookings, :request_sent_at, :datetime, default: nil
  end
end
