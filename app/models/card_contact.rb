# This class is a proxy class that allows us to treat ZapCard
# contact information just like a regular Contact.  With this we 
# can show TAP card contact information alongside the regular backed-up
# contacts like the mobile app does.
class CardContact

  attr_reader :id, :card, :first_name, :last_name, :full_name,
    :addresses, :phones, :emails

  ADDRESS_ATTRS = %w(street city state zip country)
  PHONE_ATTRS   = %w(iPhone mobile home homeFax workFax companyMain work)
  EMAIL_ATTRS   = %w(homeEmail workEmail otherEmail)

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
  end

  Phone = Struct.new(:phone_type, :phone)
  Email = Struct.new(:email_type, :email)

  def initialize(card)
    @id         = card.objectId
    @card       = card
    @first_name = card.firstName
    @last_name  = card.lastName
    @full_name  = card.first_name_last
    @addresses  = build_addresses(card)
    @phones     = build_phones(card)
    @emails     = build_emails(card)
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
      if !card.send(phone).nil?
        phones << Phone.new(phone_type(phone), card.send(phone))
      end
    end
    phones
  end

  # build an array of email addresses
  def build_emails(card)
    emails = []
    EMAIL_ATTRS.each do |email|
      if !card.send(email).nil?
        emails << Email.new(email_type(email), card.send(email))
      end
    end
    emails
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

  def self.all_by_alpha_for_user(user)
    cards = ExchangedCard.where(:cardRecipient => user.to_pointer).limit(1000).include_object(:zapCard).all
    card_contacts = cards.collect{ |card| CardContact.new(card.zapCard)}
    card_contacts.sort
  end
end