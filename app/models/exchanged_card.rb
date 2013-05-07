class ExchangedCard < ParseResource::Base

  resource_class_name 'exchangedCards'

  fields :cardRecipient, :zapCard, :cardAccepted

  belongs_to :cardRecipient, class_name: "User"
  belongs_to :zapCard,       class_name: "ZapCard"

  def self.all_for_user
    self.all.where()
  end

end