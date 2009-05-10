class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
    end
  end

  def self.down
    drop_table :comments
  end
end
