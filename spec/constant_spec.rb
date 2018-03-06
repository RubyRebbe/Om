require 'pp'
require 'byebug'
require "./models/quote.rb"
require "./models/app.rb"

describe "Constant" do
  before :all do
    @app = App.new
  end

  it "can recognize the constant key word" do
    q = Quote.new
		q.to_token( "::" )[:type].should == :bind_constant
  end

  it "can create a constant" do
    q = Quote.new( "0 zero ::" )
		@app.dot( q )
		@app.stack.should be_empty
		@app.fstack.length.should == 1
		v =  @app.get( :zero )
		v[:type].should == :constant
		v[:value].should == { type: :integer, value: 0 }
  end

  it "can evalauate a constant" do
    q = Quote.new( "zero " )
		@app.stack.should be_empty
		@app.dot( q )
		@app.stack.length.should == 1
		e = @app.stack.first
		e[:value].should == 0
  end

  it "can construct a counter object as a constant" do
		code = "{} +  [ 0 ctr : [ ctr # 1 add . ctr : ] inc : ] . counter :: "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )
		counter =  app.get( :counter )
		counter[:type].should == :constant
		counter[:value][:value][:ctr][:value].should == 0

		code = "counter [ inc # # ] ."
		q = Quote.new( code )
		app.dot( q )
		counter[:value][:value][:ctr][:value].should == 1
  end

  it "can construct a counter object with a constant method" do
		code = "{} +  [ 0 ctr : [ ctr # 1 add . ctr : ] inc :: ] . counter :: "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )

		code = "counter [ inc # ] ."
		q = Quote.new( code )
		app.dot( q )

		counter =  app.get( :counter )
		counter[:value][:value][:ctr][:value].should == 1
  end
end
