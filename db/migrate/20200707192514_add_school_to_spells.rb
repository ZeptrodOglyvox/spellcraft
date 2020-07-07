class AddSchoolToSpells < ActiveRecord::Migration[6.0]
  def change
    add_column :spells, :school, :string
  end
end
