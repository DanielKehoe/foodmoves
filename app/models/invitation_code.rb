# == Schema Information
# Schema version: 111
#
# Table name: invitation_codes
#
#  id             :integer(11)   not null, primary key
#  user_id        :integer(11)   
#  role_id        :integer(11)   
#  code           :string(255)   
#  response_count :integer(11)   default(0)
#  created_at     :datetime      
#  updated_at     :datetime      
#  sent_count     :integer(11)   default(0)
#

class InvitationCode < ActiveRecord::Base
    belongs_to :user
    belongs_to :role
    validates_uniqueness_of :code
    
    def self.find_for_user(user_id)
      find(:all,
            :conditions => ["user_id = ?", user_id],
            :order => "created_at DESC")
    end
    
end
