class CreateBandMusics < ActiveRecord::Migration[5.1]
  def change
    create_table :band_musics do |t|
      t.belongs_to :band, index: true
      t.attachment :music

      t.timestamps
    end
  end
end
