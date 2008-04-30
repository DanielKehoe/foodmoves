class Admin::AuctionphotosController < ApplicationController
  
  # GET /admin/auctionphotos
  def index
    @assets = Asset.paginate :per_page => 8,
                                  :conditions => "parent_id IS NULL and attachable_type = 'Auction'",
                                  :page => params[:page],
                                  :order => 'updated_at DESC'
  end

end
