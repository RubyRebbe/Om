module Stack
  def stack
    @stack ||= []
  end

	def push( x )
    @stack.push( x )
  end

	def pop
    @stack.pop
  end
end

module Symset
  def symset
    @symset ||= {}
  end

	def set( k, v )
    @symset[k] = v
  end

	def get( k )
    @symset[ k ]
  end
end
