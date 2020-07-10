class RemoveAbilityScoresFromCharacters < ActiveRecord::Migration[6.0]
  def change
    remove_column :characters, :intelligence, :integer
    remove_column :characters, :wisdom, :integer
    remove_column :characters, :charisma, :integer
  end
end
