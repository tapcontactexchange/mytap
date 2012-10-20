class ContactsController < ApplicationController

  def index
    # @contacts = Rails.cache.fetch('contacts') do
    #   Contact.where(:itemOwner => current_user.to_pointer)
    # end
    @contact_count = Contact.where(:itemOwner => current_user.to_pointer).count
    @contacts = Contact.where(:itemOwner => current_user.to_pointer)
  end
end
