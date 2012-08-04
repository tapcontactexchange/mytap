class ZapCard < ParseResource::Base
  
  resource_class_name 'zapCards'
  
  fields :active, :cardName, :cardOwner, :city, :company, :companyMain, :country,
         :firstName, :home, :homeEmail, :homeFax, :homePage, :iPhone, :lastName,
         :mobile, :otherEmail, :state, :street, :title, :work, :workEmail, :workFax,
         :zip
                  
  belongs_to :cardOwner, :class_name => 'User'
  
  has_many :more_infos, :inverse_of => :zapCard
  
  attr_accessor :more_info_file, :file_title

end