class LogosController < ApplicationController

  before_filter :load_owner

  protected
  
  def load_owner
    @owner = Organization.find(params[:organization_id])
  end

  public
  
  # GET /assets
  # GET /assets.xml
  def index
    @assets = @owner.assets.find(:all)
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
    end
  end

  # GET /assets/new
  def new
    @asset = @owner.assets.build
  end

  # POST /assets
  # POST /assets.xml
  def create
    if params[:asset][:uploaded_data].blank?
      failure "You tried to upload a graphic before selecting a file from your computer. " +
        "Browse and choose a graphic file first, then click &quot;Upload Logo.&quot;"
    end
    if @fail
      flash[:error] = @err_msg
      logger.error "\n#{@err_msg}\n"
      redirect_to :back
    else
      @asset = @owner.assets.build(params[:asset])
      respond_to do |format|
        if @asset.save
          case @asset.attachable_type
            when 'Organization'
              flash[:notice] = 'Logo was successfully added.'
              format.html { redirect_to organization_path(@owner) }
          end
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to organization_path(@asset.attachable_id) }
    end
  end

  private

  # set the failure flag and set an error message
  def failure(err_msg)
    @fail = true
    @err_msg = err_msg
  end
end
