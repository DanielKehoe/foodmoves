# == Schema Information
# Schema version: 111
#
# Table name: call_results
#
#  id          :integer(11)   not null, primary key
#  sort_order  :decimal(8, 2) default(50.0)
#  name        :string(255)   
#  description :string(255)   
#

class CallResult < ActiveRecord::Base
end
