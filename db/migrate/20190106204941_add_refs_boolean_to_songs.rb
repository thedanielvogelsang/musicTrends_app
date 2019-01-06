class AddRefsBooleanToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :refs_found, :boolean
  end
end
