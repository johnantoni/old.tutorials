class Client < ActiveRecord::Base
  has_many :brands, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name, :address, :phone_number, :email_address
  validates_length_of :name, :in => 3..255
  validates_length_of :address, :minimum => 10
  validates_length_of :phone_number, :in => 10..255
  validates_length_of :email_address, :maximum => 255
  validates_format_of :email_address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def update_attributes(attributes)
    self.attributes = attributes
    self.verified = false if attributes[:verified].nil?
    save
  end

end
