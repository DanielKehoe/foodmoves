class Admin::MugshotsController < ApplicationController
  
  # GET /admin/mugshots
  def index
    @mugshots = Asset.paginate :per_page => 8,
                                  :conditions => "parent_id IS NULL and attachable_type = 'User'",
                                  :page => params[:page],
                                  :order => 'updated_at DESC'
  end

end
