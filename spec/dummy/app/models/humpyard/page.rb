module Humpyard
  class Page 
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    extend ActiveModel::Naming

    define_attribute_methods [:title, :description]

    attr_accessor :title, :description
  end
end