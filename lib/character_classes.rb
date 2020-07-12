require 'CSV'

module CharacterClasses
    @filepath = 'C:\Users\Nikos\Documents\Projects\spellcraft\lib\character_classes.csv'

    def self.get_all
        subclasses = {}

        CSV.foreach(@filepath, headers: true) do |row|
            if row["subclass_of"] == "nil"
                subclasses[row["name"]] = []
            else
                subclasses[row["subclass_of"]] << row["name"]
            end
        end
        subclasses
    end
end

# class_tree = {}

# CSV.foreach(FILEPATH, headers: true) do |row|
#     # puts row.inspect
#     if row["subclass_of"] == "nil"
#         class_tree[row["name"]] = {}
#     elsif class_tree[row["subclass_of"]]
#         class_tree[row["subclass_of"]][row["name"]] = {}
#     else
#         class_tree.each do |name, subclasses|
#             if subclasses[row["subclass_of"]]
#                 subclasses[row["subclass_of"]][row["name"]] = {}
#                 break
#             end
#         end
#     end
# end

# module CharacterClass
    # def pretty_print(tree, indent)
    #     tree.each do |k, v|
    #         puts ("  " * indent) + k 
    #         pretty_print(v, indent + 1)
    #     end
    # end

#     def valid_class?(class_tree, s0, s1 = nil, s2 = nil)
#         acc = !!class_tree[s0]
#         unless !acc || class_tree[s0].empty?
#             acc &= s1 && class_tree[s0][s1]
#             unless !acc || class_tree[s0][s1].empty?
#                 acc &= s2 && class_tree[s0][s1][s2]
#             end
#         end
#         acc
#     end

#     def valid_class2(class_tree, s0, s1=nil, s2=nil)
#         class_tree.each do |k,v|
#             v.each do |k2,v2|
#                 v2.each do |k3, _|
#                 end
#             end
#         end
#     end
# end

# extend CharacterClass

# pretty_print(class_tree, 0)

# puts valid_class(class_tree, 'druid')

