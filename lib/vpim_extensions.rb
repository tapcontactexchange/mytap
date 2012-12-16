# Extensions to vCard handling gem
  
class Vpim::Vcard::Telephone

  # gets the first entry in the location or nonstandard
  # fields of the vCard phone data
  def phone_type
    type = location.first || nonstandard.first || "main"
    capes = capability.first
    if !capes.blank?
      "#{type} #{capes}"
    else
      type
    end
  end
end

class Vpim::Vcard::Email
  def email_type
    location.first || nonstandard.first || "email"
  end
end

class Vpim::Vcard::Address
  def address_type
    location.first || nonstandard.first || "home"
  end
end