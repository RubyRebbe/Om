require "./models/om_modules.rb"

class App
  include Stack
  include Symset

  # attr_accessor :symbols

	def initialize
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
      when :eval
        do_eval
      when :dot
        do_dot
      else
        push( e )
      end
		}
  end

	# stack: value symbol :
  def do_binding
    symbol = pop[:value]
		value = pop
		set( symbol, value )
  end

  def do_eval
    top = pop

		case top[:type]
		when :symbol
      symbol = top[:value]
		  e = get( symbol )
      push( e )
		when :quote
			quote = Quote.new
			quote.tree = top
			self.dot( quote )
    end
  end

	# optional_args object message .
  def do_dot
    message = pop[:value]
    object  = pop

		# defer error handling for now
		case object[:type]
    when :integer
			@integer_msgs[message].call( object )
    when :string
      # ditto :integer
    when :udo      # user defined object
    else
      # error
    end
  end
end
