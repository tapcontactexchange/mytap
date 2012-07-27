class ParseFile < ParseResource::Base
  
  attr_accessor :uploaded_file, :url, :name
  
  def content_type
    uploaded_file.content_type
  end
  
  def tempfile
    uploaded_file.tempfile
  end
  
  def filename
    uploaded_file.original_filename
  end
  
end