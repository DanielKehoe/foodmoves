# == Schema Information
# Schema version: 111
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  of_type                   :string(255)   
#  email                     :string(255)   
#  crypted_password          :string(40)    
#  salt                      :string(40)    
#  created_at                :datetime      
#  updated_at                :datetime      
#  last_login_at             :datetime      
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#  visits_count              :integer(11)   default(0)
#  time_zone                 :string(255)   default("Etc/UTC")
#  permalink                 :string(255)   
#  referred_by               :string(255)   
#  parent_id                 :integer(11)   
#  invitation_code           :string(255)   
#  first_name                :string(255)   
#  last_name                 :string(255)   
#  country                   :string(255)   
#  email_confirmed           :boolean(1)    
#  children_count            :integer(11)   
#  industry_role             :string(255)   
#  region_id                 :integer(11)   
#  country_id                :integer(11)   
#  starts_as                 :string(255)   
#  first_phone               :string(255)   
#  how_heard                 :string(255)   
#  flag_for_user_id          :integer(11)   
#  invited_again_at          :datetime      
#  blocked                   :boolean(1)    
#  do_not_contact            :boolean(1)    
#

class Guest < User
  
  validates_email_format_of :email 
  validates_uniqueness_of   :email, 
                            :case_sensitive => false,
                            :message => "has already been invited"
  # doesn't work as it should, so validate in the controller:
  # validates_presence_of :first_name, :last_name, :on => :update, :message => "can't be blank"
  # validates_presence_of :password, :on => :update, :message => "can't be blank"
  validates_confirmation_of :password, :on => :update, :message => "passwords don't match"
  
  attr_accessor :accept_terms
  attr_accessor :set_up_trading
  
  def before_save
    unless ( crypted_password ) then 
      # If the guest is being created for the first time without a password
      # we set a temporary password based on their email address.
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")
      self.crypted_password = encrypt(email)       
      # We will email them a confirmation message with a "click to confirm"
      # link that contains the crypted_password. They must have the confirmation
      # email message to register and set their own password.
    end
    unless ( region_id ) then
      self.region_id = Geographies::Region.find_by_name('North America').id
    end
    unless ( country_id ) then
      self.country_id = Geographies::Country.find_by_code('US').id
    end
    unless country_id.nil? 
      self.country = Geographies::Country.find(country_id).code.upcase
    end
    unless first_name.nil?
      unless first_name.include?(' ') 
        self.first_name = first_name.underscore # McGoo => mc_goo, Smith => smith, SMITH => smith 
        self.first_name = self.first_name.camelize # Mc_goo => McGoo, smith => Smith
      else
        self.first_name = first_name.downcase
        self.first_name = self.first_name.titleize
      end
    end
    unless last_name.nil?
      unless last_name.include?(' ') 
        self.last_name = last_name.underscore # McGoo => mc_goo, Smith => smith, SMITH => smith 
        self.last_name = self.last_name.camelize # Mc_goo => McGoo, smith => Smith
      else
        self.last_name = last_name.downcase
        self.last_name = self.last_name.titleize
      end
    end
    unless email.nil? 
      self.email.downcase!
    end
    unless first_phone.blank? 
      self.first_phone = first_phone.strip
      self.first_phone = first_phone.squeeze(' ')
      self.first_phone = first_phone.tr('(', '')
      self.first_phone = first_phone.tr(')', '')
      unless self.first_phone.index(' ') == 3
        self.first_phone = first_phone.squeeze(' ')
      end
      self.first_phone = first_phone.tr('.', ' ')
      self.first_phone = first_phone.tr('-', ' ')
    end
    if ( invitation_code ) then
      invitation = InvitationCode.find_by_code(invitation_code)
      if invitation
        # if there is an invitation code, it will specify roles, and we may have to
        # adjust the "of_type" accordingly
        role = Role.find(invitation.role_id)
        case role.title 
          when 'member' : self.of_type = 'Member'
          when 'support' : self.of_type = 'Administrator'
          when 'manager' : self.of_type = 'Administrator'
          when 'admin' : self.of_type = 'Administrator'
        end
      end
    end
  end
  
  def after_save
    # if no roles have been set, the user is new, and we need to set roles
    if ( roles.size == 0 ) then 
      # everyone gets the default role of "guest"
      guest = Role.find_by_title('guest')
      self.roles << guest
      # if there is an invitation code,
      # we set additional roles as specified by the invitation code
      if ( invitation_code ) then
        invitation = InvitationCode.find_by_code(invitation_code)
        if invitation
          admin = Role.find_by_title('admin')
          manager = Role.find_by_title('manager')
          support = Role.find_by_title('support')
          member = Role.find_by_title('member')
          # Both records must have an id in order to create the has_many :through 
          # record associating them. So we can't set the roles until after 
          # the Guest has been saved for the first time.
          role = Role.find(invitation.role_id)
          case role.title 
            when 'member' then 
              self.roles << guest
              self.roles << member
            when 'support' then 
              self.roles << guest
              self.roles << member
              self.roles << support
            when 'manager' then
              self.roles << guest
              self.roles << member
              self.roles << support
              self.roles << manager
            when 'admin' then 
              self.roles << guest
              self.roles << member
              self.roles << support
              self.roles << manager
              self.roles << admin
          end
        end            
      end
    end
  end
end
