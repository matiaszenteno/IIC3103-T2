class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums, id:false do |t|
      t.string 'id', null: false
      t.string :artist_id
      t.string :name
      t.string :genre

      t.timestamps
    end
  end
end
