class CreateSongSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :song_searches do |t|
      t.references :song, foreign_key: true
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
