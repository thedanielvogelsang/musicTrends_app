class AddCountToPossibleTags < ActiveRecord::Migration[5.2]
  def change
    add_column :possible_taggings, :count, :integer
  end
end
