# Node class
class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    self.data = data
    self.left = nil
    self.right = nil
  end
end

