class ContactsController < ApplicationController

  before_filter :alpha_index
  
  def index
    @devices = Device.find_most_recent_unique_devices_for_user(current_user)
    
    @device = @devices.first
    if params[:device]
      @devices.each{|d| @device = d if d.id == params[:device]}
    end
      
    @contact_count = Contact.where(:itemOwner => current_user.to_pointer).where(:uuid => "#{@device.uuid}").count
    @backup_contacts = Contact.all_by_alpha_for_user_device(current_user, @device)
    @card_contacts = CardContact.all_by_alpha_for_user(current_user)

    @contacts = @backup_contacts
    @selected = @contacts[@alpha_index.first].first
  end
  
  def show
    if params[:type] == "contact"
      @selected = Contact.where(:itemOwner => current_user.to_pointer).where(:objectId => params[:id]).first
    elsif params[:type] == "card_contact"
      exchanged_card = ExchangedCard.where(:cardRecipient => current_user.to_pointer).where(:objectId => params[:id]).first
      zap_card = exchanged_card.zapCard
      @selected = CardContact.new(zap_card)
    end
  end
  
  private
  
  def alpha_index
    @alpha_index = ("A".."Z").to_a << '#'
  end
end
