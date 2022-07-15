class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.belongs_to :user, index: true
      t.string :provider
      t.string :uid
      t.string :email
      t.string :access_token
      t.string :token_expires

      t.timestamps
    end
  end
end
