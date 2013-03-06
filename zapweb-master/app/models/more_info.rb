class MoreInfo < ParseResource::Base
  
  resource_class_name 'moreInfo'
  
  fields :fileName, :fileTitle, :fileType, :zapCard
  
  file_fields :image
  
  belongs_to :zap_card
  
  def valid?
    !(self.fileName.blank? || self.fileTitle.blank?)
  end
  
end