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

class Member < User
  validates_uniqueness_of :email, :on => :create, :case_sensitive => false
end
