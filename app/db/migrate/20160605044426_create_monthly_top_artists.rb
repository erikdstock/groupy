class CreateMonthlyTopArtists < ActiveRecord::Migration[5.1]
  def change
    enable_extension :jsonb
    create_table :monthly_top_artists do |t|
      t.belongs_to :artist
      t.belongs_to :user
      t.integer :play_count
      t.datetime :month
      t.jsonb :meta

      t.timestamps null: false
    end
  end
end
