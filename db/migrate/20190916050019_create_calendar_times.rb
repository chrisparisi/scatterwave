class CreateCalendarTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :calendar_times do |t|
      t.belongs_to :calendar
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
