class <%= controller_class_name %>Controller < ApplicationController
<% unless suffix -%>
  def index
    list
    render :action => 'list'
  end
<% end -%>

<% for action in unscaffolded_actions -%>
  def <%= action %><%= suffix %>
  end

<% end -%>
  def list<%= suffix %>
    @<%= singular_name %>_pages, @<%= plural_name %> = paginate :<%= plural_name %>, :per_page => 10
  end

  def new<%= suffix %>
    @<%= singular_name %> = <%= model_name %>.new
  end

  def create<%= suffix %>
    @<%= singular_name %> = <%= model_name %>.new(params[:<%= singular_name %>])
    @errors = Hash.new
    if !@errors.empty?
      redirect_to :action => 'new<%= suffix %>'
    else
      @<%= singular_name %>.save
      redirect_to :action => 'list'
    end
  end


  def edit<%= suffix %>
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
  end

  def update
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      flash[:notice] = '<%= model_name %> was successfully updated.'
      redirect_to :action => 'show<%= suffix %>', :id => @<%= singular_name %>
    else
      render :action => 'edit<%= suffix %>'
    end
  end

  def show
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
  end

  def destroy<%= suffix %>
    <%= model_name %>.find(params[:id]).destroy
    redirect_to :action => 'list<%= suffix %>'
  end
end
