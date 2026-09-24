class AddEmailChangeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_change, :string
    add_column :users, :email_change_token, :string
  end
end
