class CreateMonthlyTopArtists < ActiveRecord::Migration
  def change
    create_table :monthly_top_artists do |t|
      t.belongs_to :artist
      t.belongs_to :user
      t.integer :play_count
      t.datetime :month

      t.timestamps null: false
    end
  end
end
