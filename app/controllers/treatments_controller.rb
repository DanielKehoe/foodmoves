class TreatmentsController < ApplicationController
  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'

  roar do
    per_page 30
    order 'sort_order'

    collection do
      delete
      column :sort_order
      edit :name
      column :en_espanol
    end

    form do
      text_field :sort_order
      text_field :name
      text_field :en_espanol
    end

    filters do
      search 'Name', :fields => [:name]
    end
  end
end
