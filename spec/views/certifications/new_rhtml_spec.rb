require File.dirname(__FILE__) + '/../../spec_helper'

context "/certifications/new.rhtml" do
  include CertificationsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @certification = mock("certification")
    @certification.stub!(:to_param).and_return("99")
    @certification.stub!(:errors).and_return(@errors)
    @certification.stub!(:name).and_return("MyString")
    @certification.stub!(:url).and_return("MyString")

    assigns[:certification] = @certification
  end

  specify "should render new form" do
    render "/certifications/new.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => certifications_path, :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'certification[name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'certification[url]'}
  end
end


