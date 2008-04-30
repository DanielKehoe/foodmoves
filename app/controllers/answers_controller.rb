class AnswersController < ApplicationController

  before_filter :login_required, :except => [:index]
  access_control [:show, :edit, :destroy] => '(admin | manager | support)'

  layout 'yui_t4_doc2'

  # GET /answers
  # GET /answers.xml
  def index
    @answers = Answer.paginate :per_page => 25, 
                                  :page => params[:page],
                                  :conditions => ['answer like ? AND approved IS TRUE', "%#{params[:search]}%"], 
                                  :order => 'sort_order ASC, topic ASC'
    @pendings = Answer.find_all_by_approved(false, 
                        :order => 'created_at ASC, created_by ASC')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @answers.to_xml }
    end
  end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'admin' } # show.rhtml
      format.xml  { render :xml => @answer.to_xml }
    end
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1;edit
  def edit
    @answer = Answer.find(params[:id])
    render :layout => 'admin'
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Answer.new(params[:answer])
    @answer.created_by = @current_user.name
    @answer.topic = 'General'
    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Answer was successfully created.'
        format.html { redirect_to answers_path }
        format.xml  { head :created, :location => answer_url(@answer) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors.to_xml }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        flash[:notice] = 'Answer was successfully updated.'
        format.html { redirect_to answer_url(@answer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors.to_xml }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
      format.xml  { head :ok }
    end
  end
end
