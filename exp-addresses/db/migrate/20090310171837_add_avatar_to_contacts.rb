class AddAvatarToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :photo_file_name, :string # Original filename
    add_column :contacts, :photo_content_type, :string # Mime type
    add_column :contacts, :photo_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :contacts, :photo_file_name
    remove_column :contacts, :photo_content_type
    remove_column :contacts, :photo_file_size
  end
end
