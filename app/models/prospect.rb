# == Schema Information
# Schema version: 111
#
# Table name: organizations
#
#  id                  :integer(11)   not null, primary key
#  created_at          :datetime      
#  updated_at          :datetime      
#  name                :string(255)   
#  industry_role       :string(255)   
#  rated_by            :string(255)   default("other")
#  bluebook_member_id  :integer(6)    
#  created_by          :integer(11)   
#  of_type             :string(255)   default("Organization")
#  locality            :string(80)    
#  admin_area_id       :integer(11)   
#  country_id          :integer(11)   
#  admin_area_abbr     :string(255)   
#  country_name        :string(255)   
#  region_id           :integer(11)   
#  email               :string(80)    
#  website             :string(80)    
#  source              :string(34)    default("other")
#  created_by_name     :string(255)   
#  lat                 :decimal(15, 1 default(0.0)
#  lng                 :decimal(15, 1 default(0.0)
#  person              :string(255)   
#  thoroughfare        :string(255)   
#  postal_code         :string(255)   
#  phone               :string(255)   
#  call_result         :string(255)   default("not called")
#  updated_by          :string(255)   
#  acct_exec_id        :integer(11)   
#  paca_license        :string(30)    
#  bluebook_password   :string(30)    
#  feedback_id         :integer(11)   
#  creditworth_id      :integer(11)   
#  timeliness_id       :integer(11)   
#  integrity_id        :integer(11)   
#  needs_review        :boolean(1)    
#  liability_limits_id :integer(11)   
#  do_not_contact      :boolean(1)    
#

class Prospect < Organization

  validates_uniqueness_of :name, :case_sensitive => false

end
