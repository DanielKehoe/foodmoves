class CreateTableForTagsForPhoneAndAddress < ActiveRecord::Migration
  def self.up

    create_table :tag_for_locations do |t|
      t.column :name, :string
      t.column :sort_order, :decimal, :precision => 8, :scale => 2
      t.column :of_type, :string
    end

    TagForPhone.create :name => "home", :sort_order => 1
    TagForPhone.create :name => "work", :sort_order => 2
    TagForPhone.create :name => "cell", :sort_order => 3
    TagForPhone.create :name => "fax", :sort_order => 4    
    TagForPhone.create :name => "pager", :sort_order => 5
    TagForPhone.create :name => "messages", :sort_order => 6                      
    TagForPhone.create :name => "office", :sort_order => 7
    TagForPhone.create :name => "main number", :sort_order => 8
    TagForPhone.create :name => "direct", :sort_order => 9
    TagForAddress.create :name => "home address", :sort_order => 1
    TagForAddress.create :name => "work address", :sort_order => 2
    TagForAddress.create :name => "mailing address", :sort_order => 3
    TagForAddress.create :name => "shipping address", :sort_order => 4  
    TagForAddress.create :name => "main office address", :sort_order => 5
    TagForAddress.create :name => "branch office address", :sort_order => 6                    
    TagForAddress.create :name => "warehouse address", :sort_order => 7
  end

  def self.down
    drop_table :tag_for_locations
  end
end

