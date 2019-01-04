class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :context
      t.string :key_words, array: true

      t.timestamps
    end
  end
end
