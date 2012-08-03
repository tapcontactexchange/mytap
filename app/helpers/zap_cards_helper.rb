module ZapCardsHelper
  
  def file_link(more_info)
    return nil if more_info.nil?
    
    display_name = more_info.fileTitle
    display_name = more_info.fileName if display_name.blank?
    display_name = "More Info file" if display_name.blank?
    link_to(display_name, more_info.image.url)
    
  end
end
