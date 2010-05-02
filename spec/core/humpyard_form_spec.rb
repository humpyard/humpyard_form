require 'spec_helper'

describe HumpyardForm do

  describe 'base_director' do
    it "returns base directory" do
      HumpyardForm::base_directory.should eql File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end
  end
  
  describe 'lib_director' do
    it "returns lib directory" do
      HumpyardForm::lib_directory.should eql File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
    end
  end

end