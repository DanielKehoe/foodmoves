class AlertsController < ApplicationController
  
  layout "yui_t7_custom"
  
  def index
    if flash[:notice] then logger.warn "\nNOTICE: #{flash[:notice]}\n" end
    if flash[:error] then logger.error "\nERROR: #{flash[:error]}\n" end
    respond_to do |format|
      format.html # index.rhtml
    end
  end
  
end
