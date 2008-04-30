# == Schema Information
# Schema version: 104
#
# Table name: geographies
#
#  id                :integer(11)   not null, primary key
#  parent_id         :integer(11)   
#  children_count    :integer(11)   
#  sort_order        :decimal(8, 2) 
#  place             :boolean(1)    
#  of_type           :string(255)   
#  label             :string(255)   
#  lat               :decimal(15, 1 
#  lng               :decimal(15, 1 
#  name              :string(255)   
#  code              :string(255)   
#  three_letter_code :string(255)   
#  three_digit_code  :string(255)   
#  phone_code        :string(255)   
#  currency_code     :string(255)   
#  currency_name     :string(255)   
#  admin_by_id       :integer(11)   
#
module Geographies
  class AdminArea < Geographies::Geography
    # subclasss of Geography through single-table inheritance
  end
end