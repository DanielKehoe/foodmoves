require File.dirname(__FILE__) + '/../../spec_helper'

context "/certifications/edit.rhtml" do
  include CertificationsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @certification = mock_model(Certification, :errors => @errors)
    @certification.stub!(:name).and_return("MyString")
    @certification.stub!(:url).and_return("MyString")

    assigns[:certification] = @certification
  end

  specify "should render edit form" do
    render "/certifications/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => certification_path(@certification), :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'certification[name]'}
    response.should_have_tag 'input', :attributes =>{:name => 'certification[url]'}
  end
end


