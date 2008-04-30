require File.dirname(__FILE__) + '/../../spec_helper'

context "/packs/show.rhtml" do
  include PacksHelper
  
  setup do
    @pack = mock("pack")
    @pack.stub!(:to_param).and_return("99")
    @pack.stub!(:errors).and_return(@errors)
    @pack.stub!(:name).and_return("MyString")

    assigns[:pack] = @pack
  end

  specify "should render attributes in <p>" do
    render "/packs/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
  end
end

