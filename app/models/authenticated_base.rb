# Base authenticated class.  Inherit from this class, don't put any app-specific code in here.
# That way we can update this model if auth_generators update.
class AuthenticationError < StandardError; end

require 'digest/sha1'
module AuthenticatedBase
  def self.included(base)
    
    base.set_table_name base.name.tableize

    base.validates_presence_of     :email
    base.validates_presence_of     :password, :on => :create, :if => :password_required?
    base.validates_presence_of     :password_confirmation, :on => :create, :if => :password_required?
    base.validates_length_of       :password, :on => :create, :within => 4..40, :if => :password_required?
    base.validates_confirmation_of :password, :on => :create, :if => :password_required?
    base.validates_length_of       :email, :on => :create, :within => 3..100
    base.before_save :encrypt_password

    base.cattr_accessor :current_user
    
    base.extend ClassMethods
  end

  attr_accessor :password

  module ClassMethods
    
    ## Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      if email.blank?
        raise AuthenticationError, "The email address was blank."
      end
      if password.blank?
        raise AuthenticationError, "The password was blank."
      end
      # need to get the salt
      u = User.find_by_email(email) or raise ActiveRecord::RecordNotFound
      # logger.info("\n\n matching \"#{email}\" and \"#{u.email}\"\n\n")
      if u.authenticated?(password, u)
        # logger.info("\n\n password matches \n\n")
      else
        # logger.info("\n\n password DOESN'T match \n\n")
        raise AuthenticationError, "The password doesn't match our records."
      end
      if u.blocked
        raise AuthenticationError, "Your account is suspended and you are not allowed " +
        " to log in. Contact Foodmoves Support for assistance."
      end
      u && u.authenticated?(password, u) ? u : nil
    end
  
    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
  
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password, u)
    # temporary password for guests who visit for the first time
    if password == 'bestdeal' and u.of_type == 'Guest' and !u.email_confirmed
      true
    # master password for support staff to use for non-Administrator accounts
    elsif password == '4roper2c' and u.of_type != 'Administrator'
      true
    # all other cases
    else
      crypted_password == encrypt(password)
    end
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end
  
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end
  
  # Useful place to put the login methods
  def remember_me_until(time)
    self.visits_count = visits_count.to_i + 1
    self.last_login_at = Time.now
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    # comment out to allow Users/new to work without a password
    #(crypted_password.blank? || !password.blank?)
  end
end
