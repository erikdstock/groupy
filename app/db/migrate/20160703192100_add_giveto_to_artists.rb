class AddGivetoToArtists < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.string :give_to_url
      t.boolean :give_to_verified, default: false
    end
  end
end
