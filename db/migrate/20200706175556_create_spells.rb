class CreateSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.integer :level
      t.text :description
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :duration
      t.boolean :concentration
      t.boolean :ritual

      t.timestamps
    end
  end
end
