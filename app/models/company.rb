class Company < ParseResource::Base
  fields :companyCode

  has_many :zap_cards, inverse_of: :company
end