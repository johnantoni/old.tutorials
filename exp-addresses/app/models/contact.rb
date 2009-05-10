class Contact < ActiveRecord::Base

  belongs_to :company  

  has_attached_file :photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" }

  validates_uniqueness_of :email

  validates_length_of :email, :maximum => 255
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
    :message => 'please enter a valid email address'

  validates_length_of :phone, :in => 10..255
#  validates_format_of :phone, 
#    :with => /\d{2}-\d{3}-\d{6}/, 
#    :message => 'please use a valid format like 00 xxx xxxxxx'

end
