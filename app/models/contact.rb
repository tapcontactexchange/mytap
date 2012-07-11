class Contact < ParseResource::Base
  
  resource_class_name 'abContactBackup'
  
  fields :abItem, :abRecordId, :itemOwner
  
end