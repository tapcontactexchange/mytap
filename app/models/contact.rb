class Contact < ParseResource::Base
  
  resource_class_name 'abContactBackup'
  
  fields :abItem, :abRecordId, :itemOwner
  
  belongs_to :itemOwner, :class_name => "User"
  
  def vcard
    @vcard ||= Vpim::Vcard.decode(self.abItem).first
  end
  
  def full_name
    vcard.name.fullname unless vcard.name.nil?
  end
  
  def first_name
    vcard.name.given unless vcard.name.nil?
  end
  
  def last_name
    vcard.name.family unless vcard.name.nil?
  end
  
  def last_name_first
    if !last_name.blank? && !first_name.blank?
      "#{last_name}, #{first_name}"
    elsif !last_name.blank?
      last_name
    elsif !first_name.blank?
      first_name
    else
      full_name
    end
  end
  
  def <=>(other)
    self.last_name_first.downcase <=> other.last_name_first.downcase
  end
  
end