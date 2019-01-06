class CreatePossibleTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :possible_taggings do |t|
      t.references :song, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
