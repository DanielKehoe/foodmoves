# == Schema Information
# Schema version: 111
#
# Table name: bluebook_members
#
#  id                   :integer(11)   not null, primary key
#  bluebook_id          :integer(6)    
#  name                 :string(80)    
#  corr_trade_name_1    :string(34)    
#  corr_trade_name_2    :string(34)    
#  section              :string(1)     
#  city                 :string(34)    
#  state                :string(30)    
#  country              :string(30)    
#  county               :string(30)    
#  hqbr                 :string(1)     
#  hqbbid               :integer(6)    
#  mail_address_1       :string(34)    
#  mail_address_2       :string(34)    
#  mail_city            :string(34)    
#  mail_state           :string(30)    
#  mail_country         :string(30)    
#  mail_postal_code     :string(10)    
#  phys_address_1       :string(34)    
#  phys_address_2       :string(34)    
#  phys_city            :string(34)    
#  phys_state           :string(30)    
#  phys_country         :string(30)    
#  phys_postal_code     :string(10)    
#  voice_phone          :string(30)    
#  fax                  :string(30)    
#  tollfree             :string(30)    
#  email                :string(34)    
#  website              :string(50)    
#  license_type         :string(5)     
#  license              :string(8)     
#  chainstores          :string(1)     
#  volume               :string(6)     
#  credit_worth_rating  :string(8)     
#  integ_ability_rating :string(8)     
#  pay_rating           :string(8)     
#  rating_numerals      :string(20)    
#  created_at           :datetime      
#  updated_at           :datetime      
#

class BluebookMember < ActiveRecord::Base

  has_one :organization

  def name_plus_location
    unless country.blank?
      if country.upcase == 'USA'
        "#{name} (#{city.titlecase}, #{state.titlecase})"
      elsif country.upcase == 'CANADA'  
        "#{name} (#{city.titlecase}, #{state.titlecase}, Canada)"
      else
        "#{name} (#{city.titlecase}, #{country.titlecase})"
      end
    end
  end
  
  def location
    unless country.blank?
      if country.upcase == 'USA'
        "#{city.titlecase}, #{state.titlecase}"
      elsif country.upcase == 'CANADA'  
        "#{city.titlecase}, #{state.titlecase}, Canada"
      else
        "#{city.titlecase}, #{country.titlecase}"
      end
    end
  end

  def address_mailing
    unless mail_country.blank?
      if mail_country.upcase == 'USA'
        "#{mail_address_1.titlecase}<br />#{mail_city.titlecase}, #{mail_state} #{mail_postal_code}"
      elsif country.upcase == 'MEXICO' 
        "#{mail_address_1.titlecase}<br />#{mail_postal_code} #{mail_city.titlecase}, #{mail_state}<br />#{mail_country.titlecase}"
      else
        "#{mail_address_1.titlecase}<br />#{mail_city.titlecase}, #{mail_state} #{mail_postal_code}<br />#{mail_country.titlecase}"
      end
    end
  end
  
  def address_physical
    unless phys_country.blank?
      if phys_country.upcase == 'USA'
        "#{phys_address_1.titlecase}<br />#{phys_city.titlecase}, #{phys_state} #{phys_postal_code}"
      elsif phys_country.upcase == 'MEXICO' 
        "#{phys_address_1.titlecase}<br />#{phys_postal_code} #{phys_city}, #{phys_state}<br />#{phys_country.titlecase}"
      else
        "#{phys_address_1.titlecase}<br />#{phys_city.titlecase}, #{phys_state} #{phys_postal_code}<br />#{phys_country.titlecase}"
      end
    end
  end
  
  def thoroughfare_mailing
    unless phys_address_2.blank?
      "#{mail_address_1.titlecase} #{mail_address_2.titlecase}"
    else
      mail_address_1.titlecase
    end
  end

  def thoroughfare_physical
    unless phys_address_2.blank?
      "#{phys_address_1.titlecase} #{phys_address_2.titlecase}"
    else
      phys_address_1.titlecase
    end
  end

  def admin_area_id
    unless state.blank?
      admin_area = Geographies::AdminArea.find_by_name(state.titlecase)
      unless admin_area.id.nil?
        admin_area.id
      end
    else
      nil
    end
  end
  
  def admin_area_abbr
    unless state.blank?
      admin_area = Geographies::AdminArea.find(admin_area_id)
      admin_area.code
    else
      nil
    end
  end
  
  def admin_area_id_mailing
    unless mail_state.blank?
      admin_area = Geographies::AdminArea.find_by_code(mail_state)
      admin_area.id
    else
      nil
    end
  end
  
  def admin_area_id_physical
    unless phys_state.blank?
      admin_area = Geographies::AdminArea.find_by_code(phys_state)
      admin_area.id
    else
      nil
    end
  end

  def country_id
    unless country.blank?
      if country.upcase == 'USA'
        239
      else
        nation = Geographies::Country.find_by_name(country.titlecase)
        nation.id
      end
    end
  end
    
  def country_id_mailing
    unless mail_country.blank?
      if mail_country.upcase == 'USA'
        239
      else
        nation = Geographies::Country.find_by_name(mail_country.titlecase)
        nation.id
      end
    end
  end

  def country_id_physical
    unless phys_country.blank?
      if phys_country.upcase == 'USA'
        239
      else
        nation = Geographies::Country.find_by_name(phys_country.titlecase)
        nation.id
      end
    end
  end

  def region_id
    unless country.blank?
      if country.upcase == 'USA'
        9
      else
        nation = Geographies::Country.find_by_id(country_id)
        nation.parent.id
      end
    end
  end
   
  def region_id_mailing
    unless mail_country.blank?
      if mail_country.upcase == 'USA'
        9
      else
        nation = Geographies::Country.find_by_id(country_id_mailing)
        nation.parent.id
      end
    end
  end

  def region_id_physical
    unless phys_country.blank?
      if phys_country.upcase == 'USA'
        9
      else
        nation = Geographies::Country.find_by_id(country_id_physical)
        nation.parent.id
      end
    end
  end 
  
  def phone_country_code
    unless country.blank?
      if country.upcase == 'USA'
        1
      else
        nation = Geographies::Country.find_by_name(country.titlecase)
        nation.phone_code
      end
    end
  end 
  
  def phone_area_code
    unless country.blank?
      if country.upcase == 'USA' or country.upcase == 'CANADA'
        voice_phone.first(3)
      else
        nil
      end
    end
  end
  
  def phone_local_number
    unless country.blank?
      if country.upcase == 'USA' or country.upcase == 'CANADA'
        voice_phone.last(8)
      else
        if "#{voice_phone.first(3)}" == "#{phone_country_code} "
          voice_phone[3, voice_phone.length]
        elsif "#{voice_phone.first(4)}" == "#{phone_country_code} "
          voice_phone[4, voice_phone.length]
        else
          voice_phone
        end
      end
    end
  end
  
  def skype
    unless country.blank?
      phone_stripped = self.voice_phone.tr(' ', '')
      phone_stripped = phone_stripped.tr('-', '')
      if country.upcase == 'USA' or country.upcase == 'CANADA'
        "+1#{phone_stripped}"
      else
        if "#{voice_phone.first(3)}" == "#{phone_country_code} "
          "+#{phone_stripped}"
        elsif "#{voice_phone.first(4)}" == "#{phone_country_code} "
          "+1#{phone_stripped}"
        else
          phone_stripped
        end
      end
    else
      nil
    end
  end
    
end
