class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :comment
      t.integer :transaction_id

      t.timestamps null: false
    end
  end
end
