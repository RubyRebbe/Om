require 'byebug'
require "./models/om_modules.rb"
require "./models/frame.rb"

class FrameStack 
  include Stack

	def initialize
    stack
		push( empty_frame )
  end

	def empty_frame
		{ type: :frame, value: {} }
  end

	def set( k, v )
		stack.last[:value][k] = v
  end

	def get( k )
		stack.last[:value][k]
  end

	def length
    stack.length
  end

	def keys
		stack.last[:value].keys
  end

	def frame_stack?
    stack.reduce( true ) { |s,e| s and frame?( e ) }
  end

	def frame?( e )
    e.class == Hash &&
    e[:type] == :frame &&
		e[:value].class == Hash
  end
end
