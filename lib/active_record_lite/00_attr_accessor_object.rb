class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.count.times do |i|

      define_method(names[i]) do
         instance_variable_get("@#{names[i]}")
      end

      define_method("#{names[i]}=") do |assigned_obj|
        instance_variable_set("@#{names[i]}", assigned_obj)
      end

    end

    nil
  end
end




# names.each do |var_name|
#
#   define_method(var_name) do
#      @attributes[var_name]
#   end
#
#   define_method("#{var_name}=") do |assigned_obj|
#     @attributes[var_name] =  assigned_obj
#   end
# end