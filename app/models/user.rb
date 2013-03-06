class User < ParseUser
  # no validations included, but feel free to add your own
  validates_presence_of :username

  # you can add fields, like any other kind of Object...
  fields :firstName, :lastName, :proPackagePurchased

  # but note that email is a special field in the Parse API.
  fields :email
  
  has_many :zap_cards, :inverse_of => :cardOwner
  has_many :contacts,  :inverse_of => :itemOwner
  has_many :devices,   :inverse_of => :user
  
  def full_name
    "#{firstName} #{lastName}"
  end
  
  def pro_pack?
    proPackagePurchased
  end

  def propack_status
    proPackagePurchased ? "Active" : "Not Purchased"
  end
  
  def self.admin
    self.find_by_username '8585318451'
  end
end