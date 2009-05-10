class AddVerified < ActiveRecord::Migration
  def self.up
    add_column :clients, :verified, :boolean, :default => :false, :null => false
    add_column :brands, :verified, :boolean, :default => :false, :null => false
    add_column :products, :verified, :boolean, :default => :false, :null => false
  end

  def self.down
  end
end
