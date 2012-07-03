class ZapCard < ParseResource::Base
  
  resource_class_name 'zapCards'
  
  fields :active, :cardName, :cardOwner, :city, :city2, :company, :companyMain, :country, :country2,
         :firstName, :home, :homeEmail, :homeFax, :homePage, :iPhone, :image, :lastName
         
  belongs_to :cardOwner, :class_name => 'User'
  
  has_many :more_infos, :inverse_of => :zap_card

end