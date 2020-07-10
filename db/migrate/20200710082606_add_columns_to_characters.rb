class AddColumnsToCharacters < ActiveRecord::Migration[6.0]
  def change
    change_table :characters do |t|
      t.string :name

      t.string :race
      
      t.integer :intelligence
      t.integer :wisdom
      t.integer :charisma

      t.belongs_to :user
    end
  end
end
