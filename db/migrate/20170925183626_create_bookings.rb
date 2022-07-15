class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.references :band, foreign_key: true
      t.references :venue, foreign_key: true
      t.datetime :date
      t.datetime :start_time
      t.datetime :end_time
      t.integer :payout
      t.integer :total

      t.timestamps
    end
  end
end
