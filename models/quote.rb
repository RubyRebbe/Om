class Quote
  attr_accessor :tree

  def initialize( s = "" ) 
    @str = s
		@tree = []

		tokens = to_tokens( @str )
		# no error processing for now
		@tree = to_tree( tokens )
  end

	# produces token sequence from string
	def to_tokens( s )
		s.strip.split.map { |e| to_token( e ) }
  end

	def to_token( e )
    case e
    when "+"
      { type: :dup, value: "+" }
    when "{}"
		  { type: :frame, value: {} }
    when "["
		  { type: :open_quote, value: "[" }
    when "]"
	    { type: :close_quote, value: "]" }
    when "#"
	    { type: :eval, value: "#" }
    when "::"
	    { type: :bind_constant, value: "::" }
    when ":"
	    { type: :binding, value: ":" }
    when "."
	    { type: :dot, value: "." }
    when /"([^"]*)"/    # quoted string
			{ type: :string, value: e[1..(-2)] }
    when /[A-Za-z][A-Za-z0-9]*/
		  { type: :symbol, value: e.to_sym }
    when /[-]?[0-9]+/
			{ type: :integer, value: e.to_i }
    else # error
		  { type: :error, value: e }
    end # case
  end

	# uses explicit quote stack in place of recursive algorithm
	def to_tree( tokens )
    qstack = [ { type: :quote, value: [] } ]
  
  	while !tokens.empty? do
      t = tokens.first
  		case t[:type]
  		when :close_quote
				q = qstack.pop
				qstack.last[:value] << q
  		when :open_quote
        qstack <<  { type: :quote, value: [] }
      else
				qstack.last[:value]  << t
      end # case

  		tokens = tokens[1..(-1)]
    end
  
		# return value
		qstack.last
  end

  def empty?
		@tree[:value].empty?
  end
end

