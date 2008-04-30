require File.dirname(__FILE__) + '/../../spec_helper'

context "/assets/edit.rhtml" do
  include AssetsHelper
  
  setup do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @asset = mock_model(Asset, :errors => @errors,
      :filename => 'MyString',
      :width => '1',
      :height => '1',
      :content_type => 'image/jpeg',
      :size => '122034',
      :attachable_type => 'User',
      :attachable_id => '1',
      :updated_at => Time.now,
      :created_at => Time.now
    )
    @user = mock_model(User)

    assigns[:asset] = @asset
    assigns[:attachable] = @user

    # Views are tested in isolation here - however there are a number of helpers
    # that resource_fu creates which are defined in the controller and exposed to
    # views with helper_method().  We set expectations for calls to those helpers
    # but don't bother wiring them up - they will be tested in helper tests.
    @controller.template.should_receive(:asset_path).with(@asset).exactly(2).times.and_return('ASSET_PATH')
    @controller.template.should_receive(:assets_path).with().and_return('ASSETS_PATH')
  end

  specify "should render edit form" do
    render "/assets/edit.rhtml"
    response.should_have_tag 'form', :attributes =>{:action => 'ASSET_PATH', :method => 'post'}

    response.should_have_tag 'input', :attributes =>{:name => 'asset[filename]'}
    response.should_have_tag 'input', :attributes =>{:name => 'asset[width]'}
    response.should_have_tag 'input', :attributes =>{:name => 'asset[height]'}
    response.should_have_tag 'input', :attributes =>{:name => 'asset[content_type]'}
    response.should_have_tag 'input', :attributes =>{:name => 'asset[size]'}
    response.should_have_tag 'input', :attributes =>{:name => 'asset[attachable_type]'}
  end
end
