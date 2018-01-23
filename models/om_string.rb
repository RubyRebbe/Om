class OmString < String
  def initialize( s = "" )
   super( s )
  end

	def to_quote
   Quote.new
  end
end
