class ReplaceCasterClassFromCharacterSpecialization < ActiveRecord::Migration[6.0]
  def change
    remove_reference :character_specializations, :caster_class
    add_column :character_specializations, :character_class, :string
  end
end
