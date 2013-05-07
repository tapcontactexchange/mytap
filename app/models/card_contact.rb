# This class is a proxy class that allows us to treat TAP card
# contact information just like a regular Contact.  With this we 
# can show TAP card contact information alongside the regular backed-up
# contacts like the mobile app does.
class CardContact

  attr_reader :card, :first_name, :last_name, :full_name, :company, 
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
    @card       = card
    @first_name = card.firstName
    @last_name  = card.lastName
    @company    = card.company
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

  def build_phones(card)
    phones = []
    PHONE_ATTRS.each do |phone|
      if !card.send(phone).nil?
        phones << Phone.new(phone_type(phone), card.send(phone))
      end
    end
    phones
  end

  def build_emails(card)
    emails = []
    EMAIL_ATTRS.each do |email|
      if !card.send(email).nil?
        emails << Email.new(email_type(email), card.send(email))
      end
    end
    emails
  end

  # returns iPhone, home, company main, etc.
  def phone_type(phone)
    phone == 'iPhone' ? phone : phone.titleize.downcase
  end

  def email_type(email)
    email.titleize.split(' ').first.downcase
  end
end