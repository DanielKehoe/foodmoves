require File.dirname(__FILE__) + '/../../spec_helper'

context "/packs/index.rhtml" do
  include PacksHelper
  
  setup do
    pack_98 = mock("pack_98")
    pack_98.stub!(:to_param).and_return("98")
    pack_98.should_receive(:name).and_return("MyString")

    pack_99 = mock("pack_99")
    pack_99.stub!(:to_param).and_return("99")
    pack_99.should_receive(:name).and_return("MyString")

    assigns[:packs] = [pack_98, pack_99]
  end

  specify "should render list of packs" do
    render "/packs/index.rhtml"

    response.should_have_tag 'td', :content => "MyString"
  end
end

