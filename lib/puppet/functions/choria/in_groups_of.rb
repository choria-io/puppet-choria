# Loops over an array calling the supplied block for sub groups of it
#
# @example count to 10 in groups of 3
#
#   [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].choria::in_groups_of(3) |$grp| {
#     notice($grp)
#   }
#
# This will produce the following output:
#
#   Notice: Scope(Class[main]): [1, 2, 3]
#   Notice: Scope(Class[main]): [4, 5, 6]
#   Notice: Scope(Class[main]): [7, 8, 9]
#   Notice: Scope(Class[main]): [10]
#
# When the items are not evenly devisable by the provided size no padding
# will be done on the final yield to your lambda as shown above
Puppet::Functions.create_function(:"choria::in_groups_of") do
  dispatch :handler do
    param "Array", :items
    param "Integer", :size
    block_param
  end

  def handler(items, chunk_size)
    arr = items.clone

    count = (arr.size / Float(chunk_size)).ceil

    result = []

    count.times {|s| result <<  arr[s * chunk_size, chunk_size]}

    result.each_with_index do |a|
      yield(a)
    end
  end
end
