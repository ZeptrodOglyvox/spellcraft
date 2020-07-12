class AddDefaultCountsToAvailableSpells < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :available_spells, :counts, :boolean, default: true
      end

      dir.down do
        change_column :available_spells, :counts, :boolean, default: nil
      end
    end
  end
end
