# == Schema Information
# Schema version: 111
#
# Table name: assets
#
#  id              :integer(11)   not null, primary key
#  filename        :string(255)   
#  width           :integer(11)   
#  height          :integer(11)   
#  content_type    :string(255)   
#  size            :integer(11)   
#  attachable_type :string(255)   
#  attachable_id   :integer(11)   
#  updated_at      :datetime      
#  created_at      :datetime      
#  thumbnail       :string(255)   
#  parent_id       :integer(11)   
#  created_by_id   :integer(11)   
#

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  has_attachment :content_type => :image, 
                  :processor => :ImageScience,  
                  :storage => :s3, 
                  :max_size => 5.megabytes,
                  :resize_to => '900>',
                  :thumbnails => { :size44 => '44x44>', :size120 => '120x120>', :size200 => '200x200>'}
                    
  # removed to get thumbnails working
  # attr_accessible :uploaded_data

end
