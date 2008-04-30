# == Schema Information
# Schema version: 111
#
# Table name: roles
#
#  id          :integer(11)   not null, primary key
#  title       :string(255)   
#  description :string(255)   
#

class Role < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
  has_many :users, :through => :permissions
  has_many :invitation_codes
end
