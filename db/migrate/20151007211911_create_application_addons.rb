class CreateApplicationAddons < ActiveRecord::Migration
  def change
    create_table :application_addons do |t|
      t.integer :application_id
      t.integer :addon_id
      t.text    :params

      t.timestamps null: false
    end

    add_index :application_addons, [:application_id, :addon_id], unique: true
  end
end
