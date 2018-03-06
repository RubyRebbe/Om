require 'pp'
require 'byebug'
require "./models/om_modules.rb"
require "./models/frame_stack.rb"

class App
  include Stack
	attr_accessor :fstack

	def initialize
    @fstack = FrameStack.new

		# implement boolean as integer
		@integer_msgs = {
      add: lambda { |i|
				r = i[:value] + pop[:value]
				push( integer( r ) )
			},

			neg: lambda { |i|  push( integer( -i[:value] ) )},

      mul: lambda { |i|
				r = i[:value] * pop[:value]
				push( integer( r ) )
			},

      div: lambda { |i|
				r = i[:value] / pop[:value]
				push( integer( r ) )
			},

      mod: lambda { |i|
				r = i[:value] % pop[:value]
				push( integer( r ) )
			},
			
			# integer and boolean
      eq:  lambda { |i|
				r = om_truth( i[:value] == pop[:value] ) 
				push( integer( r ) )
			},

			# boolean
      not:  lambda { |i|
				r =  ( i[:value] - 1 ) % 2
				push( integer( r ) )
			},

      and: lambda { |i|
				r = i[:value] * pop[:value]
				push( integer( r ) )
			},

      or: lambda { |i|
				x, y = i[:value] , pop[:value]
				r = x + y - x*y
				push( integer( r ) )
			}
    }
  end

	def set( k, v )
    @fstack.set( k, v )
  end

	def get( k )
    @fstack.get( k )
  end

  def om_truth( b )
    b ? 1 : 0
  end

	def integer( x )
		{ type: :integer, value: x }
  end

	# dot executes the code in quote.tree
  def dot( quote )
		quote.tree[:value].each { |e|
      case e[:type]
      when :binding
        do_binding
      when :bind_constant
        do_bind_constant
      when :eval
        do_eval
      when :bang
				ruby = pop[:value]
				self.bang( ruby )
      when :dot
        do_dot
      when :dup
        do_dup
			when :symbol
	      v = @fstack.get( e[:value] )
				if ( v.class == Hash ) and ( v[:type] == :constant ) then
					push( v[:value] )
				else
          push( e )
        end
      else
          push( e )
      end
		}
  end

	def do_dup
    push( top )
  end

	# stack: value symbol :
  def do_binding
    symbol = pop[:value]
		value = pop
		@fstack.set( symbol, value )
  end

  def do_bind_constant
    symbol = pop[:value]
		value = pop
		@fstack.set( symbol, { type: :constant, value: value } )
  end

  def do_eval
    top = pop

		case top[:type]
		when :symbol
      symbol = top[:value]
			e = @fstack.get( symbol )
      push( e )
		when :quote
			quote = Quote.new
			quote.tree = top
			self.dot( quote )
    when :string
			quote = Quote.new( top[:value] )
			self.dot( quote )
    end
  end

	# optional_args object message .
  def do_dot
    message = pop
    object  = pop

		# defer error handling for now
		case object[:type]
    when :integer
      m = message[:value]
			@integer_msgs[m].call( object )
    when :string
      # ditto :integer
    when :frame      # user defined object
			@fstack.push( object )
			# evaluate message in context of frame

			quote = Quote.new
			case message[:type]
      when :quote
			  quote.tree = message
			  self.dot( quote )
      when :symbol
        # usr re-write rule:  frame symbol . -->  frame [ symbol # ] .
				quote.tree = { 
				  type: :quote,
				  value: [ message,  { type: :eval, value: "#" } ]
				}

			  self.dot( quote )
      end

			@fstack.pop
    else
      # error
    end
  end

	def bang( ruby )
    self.instance_eval( ruby )
  end

  def eval_file( filename)
    f = File.open( filename  )
		code = f.read
		f.close
		q = Quote.new( code )
		self.dot( q )
  end
end
