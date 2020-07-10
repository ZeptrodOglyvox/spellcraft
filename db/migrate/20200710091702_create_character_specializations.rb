class CreateCharacterSpecializations < ActiveRecord::Migration[6.0]
  def change
    create_table :character_specializations do |t|
      t.belongs_to :character 
      t.references :caster_class
      t.string :sub1
      t.string :sub2
      t.integer :level
      t.timestamps
    end

    create_table :available_spells do |t|
      t.belongs_to :character_specialization, null: false
      t.belongs_to :spell, null: false
      t.boolean :counts
      t.string :note
    end
  end
end
