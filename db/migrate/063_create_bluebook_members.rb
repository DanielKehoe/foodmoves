class CreateBluebookMembers < ActiveRecord::Migration
  def self.up
    create_table :bluebook_members do |t|
      t.column :bluebook_id, :integer, :limit	=> 6 # "113291"
      t.column :tradename, :string, :limit	=> 80 # "3 Rivers Potato Service, Inc."
      t.column :corr_trade_name_1, :string, :limit	=> 34 # "3 Rivers Potato Service, Inc."
      t.column :corr_trade_name_2, :string, :limit	=> 34 # 
      t.column :section, :string, :limit	=> 1 # "P"
      t.column :city, :string, :limit	=> 34 # "PASCO"
      t.column :state, :string, :limit	=> 30 # "WASHINGTON"
      t.column :country, :string, :limit	=> 30 # "USA"
      t.column :county, :string, :limit	=> 30 # "FRANKLIN"
      t.column :hqbr, :string, :limit	=> 1 # "H"
      t.column :hqbbid, :integer, :limit	=> 6 # "113291"
      t.column :mail_address_1, :string, :limit	=> 34 # "P.O. BOX 2791"
      t.column :mail_address_2, :string, :limit	=> 34 # 
      t.column :mail_city, :string, :limit	=> 34 # "Pasco"
      t.column :mail_state, :string, :limit	=> 30 # "WA"
      t.column :mail_country, :string, :limit	=> 30 # "USA"
      t.column :mail_postal_code, :string, :limit	=> 10 # "99302"
      t.column :phys_address_1, :string, :limit	=> 34 # "1911 SELPH LANDING RD."
      t.column :phys_address_2, :string, :limit	=> 34 # 
      t.column :phys_city, :string, :limit	=> 34 #  "Pasco"
      t.column :phys_state, :string, :limit	=> 30 # "WA"
      t.column :phys_country, :string, :limit	=> 30 # "USA"
      t.column :phys_postal_code, :string, :limit	=> 10 # "99301"
      t.column :voice_phone, :string, :limit	=> 30 # "509 547-8488"
      t.column :fax, :string, :limit	=> 30 # "509 547-0046"
      t.column :tollfree, :string, :limit	=> 30 # 
      t.column :email, :string, :limit	=> 34 # 
      t.column :website, :string, :limit	=> 50 # 
      t.column :license_type, :string, :limit	=> 5 # "PACA"
      t.column :license, :string, :limit	=> 8 # "19800438"
      t.column :chainstores, :string, :limit	=> 1 # "N"
      t.column :volume, :string, :limit	=> 6 # "2500"
      t.column :credit_worth_rating, :string, :limit	=> 8 # "50M"
      t.column :integ_ability_rating, :string, :limit	=> 8 # "XXX"
      t.column :pay_rating, :string, :limit	=> 8 # "C"
      t.column :rating_numerals, :string, :limit	=> 20 # "(60)(146)" 
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :bluebook_members
  end
end
