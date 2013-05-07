require 'test_helper'

class CardContactTest < ActiveSupport::TestCase
  
  setup do
    @card = build(:zap_card) #using FactoryGirl
  end

  test "should create card contact from card" do
    @card_contact = CardContact.new(@card)
    assert_equal @card,           @card_contact.card
    assert_equal @card.lastName,  @card_contact.last_name
    assert_equal @card.firstName, @card_contact.first_name
    assert_equal @card.company,   @card_contact.company
    assert_equal @card.first_name_last, @card_contact.full_name

    assert_not_nil(@card_contact.addresses)
    assert_equal 1, @card_contact.addresses.size

    assert_not_nil(@card_contact.phones)
    assert_equal 4, @card_contact.phones.size

    assert_not_nil(@card_contact.emails)
    assert_equal 2, @card_contact.emails.size
  end

  test "should get home address when exists" do
    @card_contact = CardContact.new(@card)
    home = @card_contact.addresses.first
    
    assert_not_nil home
    assert_equal "home", home.address_type
    assert_equal "123 Maple St.", home.street
    assert_equal "Anytown, TX 67890, USA", home.city_state_zip
  end

  test "should not get home address when it does not exist" do
    @card = build(:zap_card, street: nil, city: nil, state: nil, zip: nil, country: nil)
    @card_contact = CardContact.new(@card)
    assert @card_contact.addresses.empty?
  end

  test "should get city state zip for various provided pieces" do
    @card = build(:zap_card, zip: nil, country: nil)
    @card_contact = CardContact.new(@card)
    home = @card_contact.addresses.first
    assert_equal("Anytown, TX", home.city_state_zip)

    @card = build(:zap_card, city: nil, state: nil, country: nil)
    @card_contact = CardContact.new(@card)
    home = @card_contact.addresses.first
    assert_nil home.city_state_zip

    @card = build(:zap_card, city: nil, state: nil, zip: nil)
    @card_contact = CardContact.new(@card)
    home = @card_contact.addresses.first
    assert_equal "USA", home.city_state_zip
  end

  test "should get phone numbers when some given" do
    @card_contact = CardContact.new(@card)

    iPhone = @card_contact.phones[0]
    assert_equal "iPhone", iPhone.phone_type
    assert_equal "+1-777-777-7777", iPhone.phone

    home = @card_contact.phones[2]
    assert_equal "home", home.phone_type
    assert_equal "555-555-5555", home.phone 

    company_main = @card_contact.phones[3]
    assert_equal "company main", company_main.phone_type
    assert_equal "666-666-6666", company_main.phone
  end

  test "should not get phones when none provied" do
    @card = build(:zap_card, iPhone: nil, home: nil, mobile: nil, companyMain: nil)
    @card_contact = CardContact.new(@card)

    assert @card_contact.phones.empty?
  end

  test "should get emails" do
    @card_contact = CardContact.new(@card)


    home = @card_contact.emails.first
    assert_equal "home", home.email_type
    assert_equal "tapper@example.com", home.email

    work = @card_contact.emails.last
    assert_equal "work", work.email_type
    assert_equal "tapper@tap.com", work.email
  end

  test "should not get emails when none provided" do
    @card = build(:zap_card, homeEmail: nil, workEmail: nil, otherEmail: nil)
    @card_contact= CardContact.new(@card)

    assert @card_contact.emails.empty?
  end
end




