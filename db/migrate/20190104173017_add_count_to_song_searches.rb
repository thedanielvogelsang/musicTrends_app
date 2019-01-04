class AddCountToSongSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :song_searches, :count, :integer
  end
end
