require 'pp'
require "./models/quote.rb"
require "./models/app.rb"
require "./models/om_string.rb"

describe OmString do
  before :all do
		@oms = OmString.new( "hello" )
  end

  it "can be initialized from an ordinary string" do
		@oms.to_s.should == "hello"
  end

	it "can convert itself into a quote" do
		es = OmString.new( "" )
		es.to_quote.class.should == Quote
  end

	it "the empty string maps to the empty quote" do
		es = OmString.new( "" )
    es.to_quote.should be_empty
  end

	it "a string of om code can be evaluated ( # ) " do
    code = %( "200 800 add . " # )
		q = Quote.new( code )
    app = App.new
		app.dot( q )
		app.stack.length.should == 1
		t = app.stack.first
		t[:value].should == 1000
  end
end
