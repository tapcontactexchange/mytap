class ContactsController < ApplicationController

  before_filter :alpha_index
  
  def index
    @devices = Device.find_most_recent_unique_devices_for_user(current_user)
    
    device = @devices.first
    if params[:device]
      @devices.each{|d| device = d if d.id == params[:device]}
    end
      
    @contact_count = Contact.where(:itemOwner => current_user.to_pointer).where(:uuid => "#{device.uuid}").count
    @contacts = Contact.all_by_alpha_for_user_device(current_user, device)
    @selected = @contacts[@alpha_index.first].first
  end
  
  def show
    @selected = Contact.where(:itemOwner => current_user.to_pointer).where(:objectId => params[:id]).first
  end
  
  private
  
  def alpha_index
    @alpha_index = ("A".."Z").to_a << '#'
  end
end
