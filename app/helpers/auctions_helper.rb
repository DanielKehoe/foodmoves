module AuctionsHelper
  
  # outputs approriate path based on a passed parameter
  def helper_path(procedure, auction)
		case procedure
  		when 'ok_to_quickcopy'
  			auctions_path
  		when 'ok_to_edit'
  			auction_path(auction)
  		when 'ok_for_new'
  			auctions_path
		end
  end

  # outputs approriate path based on a passed parameter
  def helper_option(procedure, auction)

  end
  
end
