class Contact < ParseResource::Base
  
  resource_class_name 'abContactBackup'
  
  fields :firstName, :lastName, :abItem, :abRecordId, :itemOwner, :abDisplayName
  
  belongs_to :itemOwner, :class_name => "User"
  
  # To query on string values in Parse you have to use regex:
  #  
  #  Contact.where(:lastName => {"$regex" => "^A+"})
  #
  # To get a user's contacts for a specific Device:  
  def self.find_all_for_device(uuid)
    Contact.where(:itemOwner => u.to_pointer).where(:uuid => "#{uuid}")
  end
  
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
      abDisplayName
    end
  end
  
  def names
    "[#{self.lastName}] : [#{self.firstName}] : [#{self.abDisplayName}]"
  end
  
  def <=>(other)
    this_name = self.lastName || self.firstName || self.abDisplayName
    other_name = other.lastName || other.firstName || other.abDisplayName
    
    this_name.to_s.downcase <=> other_name.to_s.downcase
  end
  
end