require File.dirname(__FILE__) + '/../../spec_helper'

context "/packs/new.rhtml" do
  include PacksHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @pack = mock("pack")
    @pack.stub!(:to_param).and_return("99")
    @pack.stub!(:errors).and_return(@errors)
    @pack.stub!(:name).and_return("MyString")

    assigns[:pack] = @pack
  end

  specify "should render new form" do
    render "/packs/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => packs_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'pack[name]'}
  end
end


