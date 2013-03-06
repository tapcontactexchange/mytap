class Device < ParseResource::Base

  resource_class_name 'backupDevices'
  
  fields :deviceName, :uuid, :createdAt, :updatedAt
  
  belongs_to :user, :class_name => "User"
  
  # Devices are where the app is installed.  Contact information for a particular user can be
  # duplicated numerous times because of test intall/uninstall.  We can get the user's latest 
  # devices here.
  def self.find_most_recent_unique_devices_for_user(user)
    all_devices = Device.where(:user => user.to_pointer).order("-createdAt").all
    devices = {}
    all_devices.each do |device|
      if !devices.has_key?(device.deviceName)
        devices[device.deviceName] = device
      end
    end
    devices.values
  end
  
  def contacts(limit=1000, skip=0)
    Contact.where(:itemOwner => self.user.to_pointer).where(:uuid => self.uuid).limit(limit).skip(skip).all
  end
    
end