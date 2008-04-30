require File.dirname(__FILE__) + '/../../spec_helper'

context "/packs/edit.rhtml" do
  include PacksHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @pack = mock_model(Pack, :errors => @errors)
    @pack.stub!(:name).and_return("MyString")

    assigns[:pack] = @pack
  end

  specify "should render edit form" do
    render "/packs/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => pack_path(@pack), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'pack[name]'}
  end
end


