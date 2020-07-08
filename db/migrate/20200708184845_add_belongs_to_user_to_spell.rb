class AddBelongsToUserToSpell < ActiveRecord::Migration[6.0]
  def change
    change_table :spells do |t|
      t.belongs_to :user
    end
  end
end
