class Company < ParseResource::Base

  resource_class_name 'Company'
  
  fields :companyCode

  has_many :zap_cards, inverse_of: :company
end