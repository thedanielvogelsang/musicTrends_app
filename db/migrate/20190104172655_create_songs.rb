class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist_name
      t.integer :artist_id
      t.integer :annotation_ct

      t.timestamps
    end
  end
end
