require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    array = array.uniq.sort
    self.root = build_tree(array, 0, array.length - 1)
  end

  def build_tree(array, start, stop)
    return nil if start > stop
      
    mid = start + ((stop - start) / 2).to_i

    root = Node.new(array[mid])

    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, stop)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    return self.root = Node.new(value) if root.nil?

    current = root
    loop do
      if current.data > value
        return current.left = Node.new(value) if current.left.nil?
        current = current.left
      elsif current.data < value
        return current.right = Node.new(value) if current.right.nil?
        current = current.right
      end
    end
  end

  # Used to get successor for delete method.
  def get_successor(curr)
    curr = curr.right
    until curr.nil? || curr.left.nil?
      curr = curr.left
    end
    curr
  end

  def delete(x, root)
    return root if root.nil?

    if root.data > x
      root.left = delete(x, root.left)
    elsif root.data < x
      root.right = delete(x, root.right)
    else
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      succ = get_successor(root)
      root.data = succ.data
      root.left = delete(succ.data, root.right)
    end
    root
  end

  # Returns node with given value.
  def find(value)
    # Should I use recursion? 
    current = root
    loop do
      return current if current.data == value
      current = current.left if current.data > value

      current = current.right if current.data < value

      return current if current.nil?
    end
  end

  def level_order
    # It seems impractical to implement this with recursion.
    return nil if root.nil?
    queue = [root]
    values = []
    until queue.length == 0
      # Add left child to queue if it exists.
      queue.push(queue.first.left) unless queue.first.left.nil?
      # Add right child to queue if it exists.
      queue.push(queue.first.right) unless queue.first.right.nil?
      #Action step
      if block_given?
        values.push(yield(queue.shift))
      else
        values.push(queue.shift.data)
      end
    end
    values
  end

  def inorder(node = root, values = [], &block)
    return nil if node.nil?

    inorder(node.left, values, &block)

    if block_given?
      values.push(block.call(node))
    else
      values.push(node.data)
    end

    inorder(node.right, values, &block)

    values
  end

  def preorder(node = root, values = [], &block)
    return if node.nil?

    if block
      values.push(block.call(node))
    else
      values.push(node)
    end

    preorder(node.left, values, &block)

    preorder(node.right, values, &block)

    values
  end

  def postorder(node = root, values = [], &block)
    return if node.nil?

    postorder(node.left, values, &block)

    postorder(node.right, values, &block)

    if block
      values.push(block.call(node))
    else
      values.push(node.data)
    end
  end

  def leaf_nodes
    inorder do | node |
      if node.left.nil? && node.right.nil?
        node
      end
    end.compact
  end

  # def height(node = root, &block)
  #   return -1 if node.nil?

  #   # Find depth of every leaf node
  #   inorder(node, &block) do | node |
  #     if node.left.nil? && node.right.nil?

  # end

  def depth(root, node)
    return -1 if root.nil?

    distance = -1

    return distance + 1 if root == node
    distance = depth(root.left, node)
    return distance + 1 if distance >= 0
    distance = depth(root.right, node)
    return distance + 1 if distance >= 0
    return distance
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)

tree.pretty_print
p tree.leaf_nodes



