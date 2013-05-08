# This class is a proxy class that allows us to treat ZapCard
# contact information just like a regular Contact.  With this we 
# can show TAP card contact information alongside the regular backed-up
# contacts like the mobile app does.
class CardContact

  attr_reader :id, :card, :first_name, :last_name, :full_name, :company,
    :addresses, :phones, :emails

  ADDRESS_ATTRS = %w(street city state zip country)
  PHONE_ATTRS   = %w(iPhone mobile home homeFax workFax companyMain work)
  EMAIL_ATTRS   = %w(homeEmail workEmail otherEmail)

  # aliases to allow comparing Contact to CardContact
  alias :firstName :first_name
  alias :lastName :last_name
  alias :abDisplayName :full_name 

  Address = Struct.new(:address_type, :street, :city, :state, :zip, :country) do

    def city_state_zip
      csz = nil
      if !city.blank? && !state.blank?
        csz = "#{city}, #{state}"
      end
      if !zip.blank? && !csz.blank?
        csz += " #{zip}"
      end
      if !country.blank?
        if csz
          csz += ", #{country}"
        else
          csz = "#{country}"
        end
      end
      csz
    end

    def has_address?
      !(street.blank? && city.blank? && state.blank?)
    end
  end

  Phone = Struct.new(:phone_type, :phone) do
    def to_s
      self.phone
    end
  end

  Email = Struct.new(:email_type, :email) do
    def to_s
      self.email
    end
  end

  def initialize(card)
    @id         = card.id
    @card       = card
    @first_name = card.firstName
    @last_name  = card.lastName
    @company    = build_company(card)
    @full_name  = card.first_name_last
    @addresses  = build_addresses(card)
    @phones     = build_phones(card)
    @emails     = build_emails(card)
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

  alias :last_name_first_safe :last_name_first

  # gets the company name if one is provided
  def build_company(card)
    company = card.company
    if company
      company.companyCode.titleize
    else
      nil
    end
  end
  # build an address from the city, state, etc. attributes, but only
  # if there's a value in at least one of them, otherwise return an 
  # empty array
  def build_addresses(card)
    addresses = []
    if ADDRESS_ATTRS.collect{|attr| card.send(attr)}.any?
      addresses = [Address.new('home', card.street, card.city, card.state, card.zip, card.country)]
    end
    addresses
  end

  # build an array of phone numbers
  def build_phones(card)
    phones = []
    PHONE_ATTRS.each do |phone|
      if !card.send(phone).blank?
        phones << Phone.new(phone_type(phone), card.send(phone))
      end
    end
    phones
  end

  # build an array of email addresses
  def build_emails(card)
    emails = []
    EMAIL_ATTRS.each do |email|
      if !card.send(email).blank?
        emails << Email.new(email_type(email), card.send(email))
      end
    end
    emails
  end

  def company
    nil  
  end

  # returns 'iPhone', 'home', 'company main', etc.
  def phone_type(phone)
    phone == 'iPhone' ? phone : phone.titleize.downcase
  end

  # retuns 'home', 'work', etc.
  def email_type(email)
    email.titleize.split(' ').first.downcase
  end

  def <=>(other)
    this_name = self.last_name || self.first_name || self.full_name
    other_name = other.last_name || other.first_name || other.full_name
    
    this_name.to_s.downcase <=> other_name.to_s.downcase
  end

  # Creates a collection of +CardContacts+ for each of the user's +ExchangedCards+.  It gets the
  # +ZapCard+ from each +ExchangedCard+ and creates a Contact Card from it, then groups them
  # by the first letter of the last name.
  def self.all_by_alpha_for_user(user)
    cards = ExchangedCard.where(:cardRecipient => user.to_pointer).limit(1000).include_object(:zapCard).all
    contacts = cards.collect{ |card| CardContact.new(card.zapCard)}
    contacts.sort

    grouped_contacts = contacts.group_by{|c| c.last_name_first.upcase[0]}
    non_alpha_keys = grouped_contacts.keys - ("A".."Z").to_a
    non_alpha_keys.each do |key|
      grouped_contacts.has_key?('#') ? grouped_contacts['#'] += grouped_contacts[key] 
                                     : grouped_contacts['#'] = grouped_contacts[key]
      grouped_contacts.delete(key)
    end
    grouped_contacts
  end

  def to_s
    "#<#{self.class.name}: #{last_name}, #{first_name}>"
  end

  # merges two sets of grouped contacts into a single grouped set, 
  # ordered by last_name, first_name
  def self.merge_contacts(contacts, card_contacts)
    contacts.each_key do |k|
      if card_contacts.has_key?(k)
        sort_merge!(k, contacts, card_contacts)
      end
    end

    # merge in the remaining keys from card_contacts
    contacts.merge!(card_contacts)
  end

  # merges the values of +key+ from card_contacts into
  # contacts, sorting the items as they're merged, then
  # deletes the key from card_contacts
  def self.sort_merge!(key, contacts, card_contacts)
    contacts[key] += card_contacts[key]
    contacts[key].sort!{|c1, c2| sort_contacts(c1, c2)}
    card_contacts.delete(key)
    contacts[key]
  end

  # compares 
  def self.sort_contacts(c1, c2)
    if c1.is_a?(c2.class)
      c1 <=> c2
    else
      if c1.is_a? Contact
        compare_contacts(c1, c2)
      else
        compare_contacts(c2, c1)
      end
    end
  end

  # compares a Contact and a CardContact for sorting
  def self.compare_contacts(contact, card_contact)    
    contact.last_name_first.to_s.downcase <=> card_contact.last_name_first.to_s.downcase
  end
end