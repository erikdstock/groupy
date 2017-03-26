class AddGivetoToArtists < ActiveRecord::Migration[5.1]
  def change
    change_table :artists do |t|
      t.string :give_to_url
      t.boolean :give_to_verified, default: false
    end
  end
end
