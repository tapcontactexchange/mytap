class Contact < ParseResource::Base
  
  resource_class_name 'abContactBackup'
  
  fields :firstName, :lastName, :abItem, :abRecordId, :itemOwner, :abDisplayName
  
  belongs_to :itemOwner, :class_name => "User"
  
  # To query on string values in Parse you have to use regex:
  #  
  #  Contact.where(:lastName => {"$regex" => "^A+"})
  #
  # To get a user's contacts for a specific Device:    
  def self.all_for_user_device(user, device)
    total_contacts = self.contact_query(user, device).count
    contacts = []
    while total_contacts > 0 && contacts.size < total_contacts do
      contacts += self.contact_query(user, device).limit(1000).skip(contacts.size).all
    end
    contacts.sort
  end
  
  # retrieve all the contacts for a user and device then
  # group them in a hash with keys representing the first letter of the contact name
  # group all the non-alpha contacts names in a single group 
  def self.all_by_alpha_for_user_device(user, device)
    contacts = self.all_for_user_device(user, device)
    grouped_contacts = contacts.group_by{|c| c.last_name_first.upcase[0]}
    non_alpha_keys = grouped_contacts.keys - ("A".."Z").to_a
    non_alpha_keys.each do |key|
      grouped_contacts.has_key?('#') ? grouped_contacts['#'] += grouped_contacts[key] 
                                     : grouped_contacts['#'] = grouped_contacts[key]
      grouped_contacts.delete(key)
    end
    grouped_contacts
  end
  
  # vCard phones format:
  #   display: display value of phone number
  #   location: work/home/cell 
  #
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
  
  def phones
    @phones ||= vcard.telephones
  end
  
  def emails
    @emails ||= vcard.emails
  end
  
  def addresses
    @addresses ||= vcard.addresses
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
  
  def company
    vcard.org.try(:first)
  end
  
  def names
    "[#{self.lastName}] : [#{self.firstName}] : [#{self.abDisplayName}]"
  end
  
  def <=>(other)
    this_name = self.lastName || self.firstName || self.abDisplayName
    other_name = other.lastName || other.firstName || other.abDisplayName
    
    this_name.to_s.downcase <=> other_name.to_s.downcase
  end
  
  def self.admin_contacts
    User.admin.contacts.all
  end
  
  private
  
  def self.contact_query(user, device)
    Contact.where(:itemOwner => user.to_pointer).where(:uuid => "#{device.uuid}")
  end
  
end