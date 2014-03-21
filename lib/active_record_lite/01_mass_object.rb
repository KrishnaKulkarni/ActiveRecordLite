# deprecated for Rails 4
require_relative '00_attr_accessor_object.rb'

class MassObject < AttrAccessorObject

  def self.attributes
    if self == MassObject
      raise "must not call #attributes on MassObject directly"
    end
    {}
  end

  def initialize(params = {})
    params.each do |ivar_symbol, value|
      self.send("#{ivar_symbol}=", value)
    end
  end
end
