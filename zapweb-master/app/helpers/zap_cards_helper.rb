module ZapCardsHelper
  
  def file_link(more_info)
    return nil if more_info.nil?
    
    file_type = "file_link " + file_link_class(more_info)
    
    display_name = more_info.fileTitle
    display_name = more_info.fileName if display_name.blank?
    display_name = "More Info file" if display_name.blank?
    link_to(display_name, more_info.image.url, :class => file_type)
  end

  def file_link_class(more_info)
  	file_type = more_info.fileType.to_s
  	if ['jpg', 'jpeg', 'image'].include?(file_type)
  		'jpg'
  	else
  		file_type
  	end
  end
end
