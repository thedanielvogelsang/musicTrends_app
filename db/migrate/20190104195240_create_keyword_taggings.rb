class CreateKeywordTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :keyword_taggings do |t|
      t.references :keyword, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
