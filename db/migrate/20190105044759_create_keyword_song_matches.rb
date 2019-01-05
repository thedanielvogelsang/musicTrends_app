class CreateKeywordSongMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :keyword_song_matches do |t|
      t.references :keyword, foreign_key: true
      t.references :song, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
