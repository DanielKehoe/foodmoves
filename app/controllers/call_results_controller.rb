class CallResultsController < ApplicationController
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)',
                  :destroy => 'admin'

  roar do
    per_page 30
    order 'sort_order'

    collection do
      column :sort_order
      edit :name
      column :description
    end

    form do
      text_field :sort_order
      text_field :name
      text_field :description
    end

    filters do
      search 'Name', :fields => [:name]
    end
  end
end