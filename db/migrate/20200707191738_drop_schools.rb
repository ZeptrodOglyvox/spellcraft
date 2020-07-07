class DropSchools < ActiveRecord::Migration[6.0]
  def change
    drop_table :schools
    drop_table :schools_spells
  end
end
