class HowHeardsController < ApplicationController

  # from acl_system2 example
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager)'

  roar do
    per_page 30
    order 'sort_order'

    collection do
      delete
      column :sort_order
      edit :answer
    end

    form do
      text_field :sort_order
      text_field :answer
    end

    filters do
      search 'Answer', :fields => [:answer]
    end
  end
end