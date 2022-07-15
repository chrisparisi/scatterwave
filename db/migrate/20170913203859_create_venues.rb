class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string :venue_type
      t.string :gig_type
      t.integer :capacity
      t.string :listing_name
      t.text :summary
      t.text :comments
      t.string :address
      t.boolean :is_alternative
      t.boolean :is_americana
      t.boolean :is_blues
      t.boolean :is_christian
      t.boolean :is_classical
      t.boolean :is_comedy
      t.boolean :is_country
      t.boolean :is_edm
      t.boolean :is_electronic
      t.boolean :is_folk
      t.boolean :is_hiphop
      t.boolean :is_jazz
      t.boolean :is_latin
      t.boolean :is_metal
      t.boolean :is_pop
      t.boolean :is_rb
      t.boolean :is_rock
      t.boolean :is_spokenword
      t.boolean :is_world
      t.integer :payout
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
