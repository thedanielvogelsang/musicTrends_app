class AddRefsBooleanToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :refs_found, :boolean, :default => true
  end
end
