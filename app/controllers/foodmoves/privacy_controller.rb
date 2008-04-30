class Foodmoves::PrivacyController < ApplicationController

  # no access control, no need to log in or have privileges

  layout 'yui_t4_doc2'

  def index
    respond_to do |format|
      format.html # index.rhtml
    end
  end      
end

