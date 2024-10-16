require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    unique_array = array.uniq.sort
    self.root = build_balanced_tree(unique_array, 0, unique_array.length - 1)
  end

  def build_balanced_tree(sorted_array, start, stop)
    return nil if start > stop

    mid = start + ((stop - start) / 2).to_i

    root = Node.new(sorted_array[mid])
    p root

    root.left = build_balanced_tree(sorted_array, start, mid - 1)
    root.right = build_balanced_tree(sorted_array, mid + 1, stop)
    
    return root
  end
end

tree = Tree.new([5, 4, 3, 2, 1])

p tree.root