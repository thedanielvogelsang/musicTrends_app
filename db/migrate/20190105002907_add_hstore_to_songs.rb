class AddHstoreToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :word_dict, :hstore, default: {}
  end
end
