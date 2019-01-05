class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :text
      t.integer :search_type, :default => 0
      t.integer :count

      t.timestamps
    end
  end
end
