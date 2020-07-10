class AddSpellcastingAbilityScoreToCharacterSpecializations < ActiveRecord::Migration[6.0]
  def change
    add_column :character_specializations, :spellcasting_ability_score, :integer
  end
end
