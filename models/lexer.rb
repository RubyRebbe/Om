require 'byebug'

class Lexer
  attr_accessor :reserved_words

	def initialize
    @reserved_words = [
      { type: :dup, value: "+" },
		  { type: :frame, value: "{}" },
		  { type: :open_quote, value: "[" },
	    { type: :close_quote, value: "]" },
	    { type: :eval, value: "#" },
	    { type: :bind_constant, value: "::" },
	    { type: :binding, value: ":" },
	    { type: :bang, value: "!" },
	    { type: :dot, value: "." }
    ]
  end

  def to_tokens( str )
    r = []

    while str != "" do
      s = whitespace( str )

			if s != nil then
        l = s.length
				str = str[l..(-1)]
      elsif ( t = reserved_word( str ) ) != nil then
				at = { type: t[:type], value: t[:value] }
				if t[:type] == :frame then
				  at[:value] = {}
				end

				r << at
				l = t[:value].length
				str = str[l..(-1)]
      elsif (t = integer( str ) ) != nil then
				r << t
				l = t[:value].to_s.length
				str = str[l..(-1)]
      elsif (t = symbol( str ) ) != nil then
				r << t
				l = t[:value].to_s.length
				str = str[l..(-1)]
      elsif (t = string( str ) ) != nil then
				r << t
				l = t[:value].to_s.length + 2
				str = str[l..(-1)]
      end
			# no error handling so far
    end

		r
  end

	def whitespace( str )
    index = ( /^\s+/ =~ str )
		( index == nil or index > 0 ) ? nil : $~.to_s
  end

	def reserved( res , str )
    i = str.index( res )
		if i == nil or i != 0 then
      nil
    else
      res
    end
  end

  def reserved_word( str )
    @reserved_words.find { |e| reserved( e[:value], str ) == e[:value]  }
  end

	def integer( str )
    index = ( /[-]?[0-9]+/ =~ str )
		( index == nil or index > 0 ) ? nil : { type: :integer, value: $~.to_s.to_i  }
  end

	def symbol( str )
    index = ( /[A-Za-z][A-Za-z0-9]*/ =~ str )
		( index == nil or index > 0 ) ? nil : { type: :symbol, value: $~.to_s.to_sym }
  end

	def string( str )
    index = (  /"([^"]*)"/ =~ str )
		( index == nil or index > 0 ) ? nil : 
  		{ type: :string, value: $~.to_s[1..-2] }
  end
end
