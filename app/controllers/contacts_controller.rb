class ContactsController < ApplicationController

  before_filter :alpha_index
  
  def index
    # @contacts = Rails.cache.fetch('contacts') do
    #   Contact.where(:itemOwner => current_user.to_pointer)
    # end
    
    @devices = Rails.cache.fetch('devices') do
      Device.find_most_recent_unique_devices_for_user(current_user)
    end
    
    device = @devices.first
    if params[:device]
      @devices.each{|d| device = d if d.id == params[:device]}
    end
      
    @contact_count = Contact.where(:itemOwner => current_user.to_pointer).where(:uuid => "#{device.uuid}").count
    @contacts = Rails.cache.fetch('contacts') do
      Contact.all_by_alpha_for_user_device(current_user, device)
    end
  end
  
  private
  
  def alpha_index
    @alpha_index = ("A".."Z").to_a << '#'
  end
end
