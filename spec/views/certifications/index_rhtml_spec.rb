require File.dirname(__FILE__) + '/../../spec_helper'

context "/certifications/index.rhtml" do
  include CertificationsHelper
  
  setup do
    certification_98 = mock("certification_98")
    certification_98.stub!(:to_param).and_return("98")
    certification_98.should_receive(:name).and_return("MyString")
    certification_98.should_receive(:url).and_return("MyString")

    certification_99 = mock("certification_99")
    certification_99.stub!(:to_param).and_return("99")
    certification_99.should_receive(:name).and_return("MyString")
    certification_99.should_receive(:url).and_return("MyString")

    assigns[:certifications] = [certification_98, certification_99]
  end

  specify "should render list of certifications" do
    render "/certifications/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
    response.should_have_tag 'td', :content => "MyString"
  end
end

