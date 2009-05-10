class Product < ActiveRecord::Base
  belongs_to :brand
  
  validates_uniqueness_of :product_code
  validates_uniqueness_of :name, :scope => [:brand_id]
  validates_presence_of :name, :description, :product_code
  validates_length_of :name, :in => 3..255
  validates_length_of :description, :minimum => 10
  validates_length_of :product_code, :in => 3..255

  def update_attributes(attributes)
    self.attributes = attributes
    self.verified = false if attributes[:verified].nil?
    save
  end

end
