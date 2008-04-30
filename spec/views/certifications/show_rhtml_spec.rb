require File.dirname(__FILE__) + '/../../spec_helper'

context "/certifications/show.rhtml" do
  include CertificationsHelper
  
  setup do
    @certification = mock("certification")
    @certification.stub!(:to_param).and_return("99")
    @certification.stub!(:errors).and_return(@errors)
    @certification.stub!(:name).and_return("MyString")
    @certification.stub!(:url).and_return("MyString")

    assigns[:certification] = @certification
  end

  specify "should render attributes in <p>" do
    render "/certifications/show.rhtml"

    # response.should_have_tag('p', :content => "MyString")
    # response.should_have_tag('p', :content => "MyString")
  end
end

