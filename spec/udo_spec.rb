require "./models/om_modules.rb"

class Udo
  include Symset
end

# build it out using stack object as example
describe Udo do
  before :all do
    @stk = Udo.new
  end

  it "is a user-defined object" do
    @stk.should_not be nil
  end

	it "has a set of of slots, by default empty" do
	  @stk.symset.should be_empty
  end

	it "each slot is a symbol-value pair" do
		@stk.symset.class.should == Hash	
	end

	it "a slot can contain an ordinary value" do
    @stk.set( :storage, Quote.new )
		@stk.symset.keys.should == [ :storage ]
		q = @stk.get( :storage )
		q.class.should == Quote
		q.should be_empty
  end

	it "a slot can contain a quote to be evaluated in context of udo" do
    q = Quote.new( "storage # empty . " )
		@stk.set( :empty, q )
  end

	it "udo context extends App context (udo algebra + or add)"

	it "a slot can contain an executable value - method body"
	it "responds to the message expression"
	it "variable resolution boils down to getter-setter method against some object"
	it "honors the law of Demeter"
	it "an Udo defines a single instance, not a type"
end
