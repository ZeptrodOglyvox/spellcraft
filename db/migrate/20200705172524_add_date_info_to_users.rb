class AddDateInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :signed_up_on, :datetime
    add_column :users, :last_sign_in, :datetime
  end
end
