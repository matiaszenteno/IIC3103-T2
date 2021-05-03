class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks, id: false do |t|
      t.string 'id', null: false
      t.string :album_id
      t.string :name
      t.float :duration
      t.integer :times_played

      t.timestamps
    end
  end
end
