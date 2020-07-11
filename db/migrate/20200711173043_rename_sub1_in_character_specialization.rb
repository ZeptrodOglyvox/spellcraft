class RenameSub1InCharacterSpecialization < ActiveRecord::Migration[6.0]
  def change
    rename_column :character_specializations, :sub1, :subclass
  end
end
