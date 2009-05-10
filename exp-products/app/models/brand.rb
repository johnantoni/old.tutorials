class Brand < ActiveRecord::Base
  belongs_to :client
  has_many :products, :dependent => :destroy
  
  validates_uniqueness_of :name, :scope => [:client_id]
  validates_presence_of :name, :description
  validates_length_of :name, :in => 3..255
  validates_length_of :description, :minimum => 10

  def update_attributes(attributes)
    self.attributes = attributes
    self.verified = false if attributes[:verified].nil?
    save
  end

end
