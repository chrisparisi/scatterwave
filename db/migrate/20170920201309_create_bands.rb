class CreateBands < ActiveRecord::Migration[5.1]
  def change
    create_table :bands do |t|
      t.string :band_type
      t.string :band_genre
      t.string :band_sec_genre
      t.string :band_name
      t.string :sound_link
      t.string :face_link
      t.string :spot_link
      t.text :summary
      t.string :address
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
