class MoreInfo < ParseResource::Base
  
  resource_class_name 'moreInfo'
  
  fields :fileType, :image, :zapCard
  
  belongs_to :zap_card

end