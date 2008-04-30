class IntegritiesController < ApplicationController
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'

  roar do
    per_page 30
    order 'sort_order'

    collection do
      column :sort_order
      edit :description
      delete
    end

    form do
      text_field :sort_order
      text_field :description
    end

    filters do
      search 'Name', :fields => [:description]
    end
  end
end