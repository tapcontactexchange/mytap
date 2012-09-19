class ContactsController < ApplicationController

  def index
    # @contacts = Rails.cache.fetch('contacts') do
    #   Contact.where(:itemOwner => current_user.to_pointer)
    # end
    @contacts = Contact.where(:itemOwner => current_user.to_pointer)
  end
end
