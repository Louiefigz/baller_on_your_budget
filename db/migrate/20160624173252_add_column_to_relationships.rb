class AddColumnToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :friendship_id, :integer

  end
end
