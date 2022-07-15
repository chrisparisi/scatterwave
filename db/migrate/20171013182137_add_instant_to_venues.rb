class AddInstantToVenues < ActiveRecord::Migration[5.1]
  def change
    add_column :venues, :instant, :integer, default: 0
  end
end
