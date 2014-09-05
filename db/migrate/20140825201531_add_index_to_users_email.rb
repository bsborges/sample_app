class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true # to be an unique attribute and to speed up find_by(email: email)
  end
end
