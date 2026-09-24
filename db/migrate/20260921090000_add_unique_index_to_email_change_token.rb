class AddUniqueIndexToEmailChangeToken < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :email_change_token, unique: true
  end
end
