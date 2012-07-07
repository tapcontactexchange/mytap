class MoreInfo < ParseResource::Base
  
  resource_class_name 'moreInfo'
  
  fields :fileName, :fileType, :image, :zapCard
  
  belongs_to :zap_card

end