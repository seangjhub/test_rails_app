class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :handle_id, null: false
      t.string :encrypted_password, null: false

      t.integer :failed_login_count, null: false, default: 0
      t.boolean :is_locked, null: false, default: false

      t.timestamps
      t.index :handle_id, unique: true, length: 191
    end
  end
end
