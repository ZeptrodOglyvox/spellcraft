class CreateCasterClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :caster_classes do |t|
      t.string :name

      t.timestamps
    end
  end

  create_join_table :caster_classes, :spells
end
