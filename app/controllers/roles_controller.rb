class RolesController < ApplicationController
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => 'admin'

  roar do
    per_page 30
 
    collection do
      delete
      edit :title
      column :description
    end
 
    form do
      text_field :title
      text_field :description
    end
 
    filters do
      search 'Role Title', :fields => [:title]
    end
  end
end
