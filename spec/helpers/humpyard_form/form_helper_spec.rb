require 'spec_helper'

describe HumpyardForm::ActionView::FormHelper do
  include HumpyardForm::ActionView::FormHelper

  # DAMN! how to get a view context into the spec context?
  # then we would not have to stub all those methods below
  # and would be able to actually render something
  # and check if its right. also, we would not have to
  # include the clutter above.
  
  describe '#humpyard_form_for' do

    it 'yields an instance of FormBuilder' do
      @page = mock_model(Humpyard::Page)
      self.stub!(:convert_to_model).and_return(Humpyard::Page)
      self.stub!(:humpyard_pages_path).and_return("/humpyard/pages")
      self.stub!(:capture_haml).and_return("Hepp")
      self.stub!(:render).and_return("Repp")
      humpyard_form_for(@page) do |builder|
        builder.class.should == ::Humpyard::FormBuilder
      end
    end
        
  end
end
