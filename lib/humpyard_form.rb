####
# Welcome to HumpyardForm

module HumpyardForm
  # This is the actual version of the HumpyardForm gem
  VERSION = ::File.read(::File.join(::File.dirname(__FILE__), "..", "VERSION")).strip  
    
  def self.load options = {} #:nodoc:
    require ::File.expand_path('../humpyard_form/rake_tasks', __FILE__)
  end
  
  # This is the path to the HumpyardForm gem's root directory
  def base_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end
  
  # This is the path to the HumpyardForm gem's lib directory
  def lib_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__)))
  end
    
  module_function :base_directory, :lib_directory

  class << self    
    # To access the actual configuration of your HumpyardForm, you can call this.
    #
    # An example would be <tt>HumpyardForm.config.www_prefix = 'cms/:locale/'</tt>
    #
    # See HumpyardForm::Config for configuration options.
    def config
      @config ||= HumpyardForm::Config.new
    end

    # Configure the HumpyardForm 
    # See HumpyardForm::Config.configure for details
    def configure(&block)
      config.configure(&block)
    end
  end
end

require File.expand_path('../humpyard_form/config', __FILE__)
require File.expand_path('../humpyard_form/engine', __FILE__)
require File.expand_path('../humpyard_form/compass', __FILE__)

require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
puts "=> #{I18n.t 'humpyard_form.start', :version => HumpyardForm::VERSION}"

require File.expand_path('../humpyard_form/action_controller/base', __FILE__)
require File.expand_path('../humpyard_form/action_view/form_helper', __FILE__)


