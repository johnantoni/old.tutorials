class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.text :address
      t.string :phone_number
      t.string :email_address

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
