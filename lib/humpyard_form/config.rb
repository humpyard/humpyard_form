module HumpyardForm
  ####
  # HumpyardForm::Config is responsible for holding and managing the configuration
  # for your HumpyardForm Rails Application.
  #
  # Possible configuration options are:
  # +table_name_prefix+:: 
  #    The prefix for the SQL tables
  #
  #    The default value is <tt>"humpyard_form_"</tt>
  # +admin_prefix+::      
  #    The prefix for the admin controllers
  #
  #    The default value is <tt>"admin"</tt>

  class Config 
    def initialize(&block) #:nodoc:
      configure(&block) if block_given?
    end

    # Configure your HumpyardForm Rails Application with the given parameters in 
    # the block. For possible options see above.
    def configure(&block)
      yield(self)
    end
  end
end