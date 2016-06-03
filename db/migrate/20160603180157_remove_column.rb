class RemoveColumn < ActiveRecord::Migration
  def change
    remove_column :users, :relationship
  end
end
