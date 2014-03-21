class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |var_name|

      define_method(var_name) do
         self.attributes[var_name.to_sym]
      end

      define_method("#{var_name}=") do |assigned_obj|
        self.attributes[var_name.to_sym] =  assigned_obj
      end
    end

    nil
  end
end







# names.count.times do |i|
#
#   define_method(names[i]) do
#      instance_variable_get("@#{names[i]}")
#   end
#
#   define_method("#{names[i]}=") do |assigned_obj|
#     instance_variable_set("@#{names[i]}", assigned_obj)
#   end
#
# end