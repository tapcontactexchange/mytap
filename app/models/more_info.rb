class MoreInfo < ParseResource::Base
  
  resource_class_name 'moreInfo'
  
  fields :fileName, :fileTitle, :fileType, :zapCard
  
  file_fields :image
  
  belongs_to :zap_card

  MAX_FILES = 12
  
  def valid?
    !(self.fileName.blank? || self.fileTitle.blank?)
  end
  
end