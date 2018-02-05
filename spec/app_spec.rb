require 'pp'
require "./models/quote.rb"
require "./models/app.rb"

describe App do
  before :all do
    @app = App.new
  end

	it "can create an om app" do
    @app.class.should == App
  end

	it "has a dot method" do
		@app.public_methods( false).should include :dot
  end

	it "method dot takes a single argument, a Quote" do
    quote = Quote.new
		@app.dot( quote )
  end

	it "app has a stack, initially empty" do
		@app.stack.should be_empty
  end

	it "method dot can evaluate the empty quote" do
    quote = Quote.new
		quote.should be_empty
		@app.stack.should be_empty

		@app.dot( quote )
		@app.stack.should be_empty
  end

	it "can interpret the program '[ ]' " do
    @app.stack.clear
		@app.stack.should be_empty

    quote = Quote.new( " [ ] " )
		@app.dot( quote )
		@app.stack.length.should == 1
		@app.stack.first.class.should == Hash
		@app.stack.first.should == { type: :quote, value: [] }
  end

	it "can interpret a binding" do
    @app.stack.clear
    #@app.symset.should be_empty
		@app.fstack.length.should == 1
    quote = Quote.new( " 360 x :  " )

		@app.dot( quote )

		@app.stack.should be_empty
		@app.fstack.keys.should == [ :x ]
		@app.fstack.get( :x )[:value].should == 360
  end

	it "can evaluate a symbol" do
    @app.stack.clear
    quote = Quote.new( " x #  " )
		@app.dot( quote )
		@app.stack.length.should == 1
		@app.stack.first[:value].should == 360
  end

	it "can evaluate a quote" do
    @app.stack.clear
    quote = Quote.new( " [ 1028 y : ] # " )
		@app.dot( quote )
		@app.fstack.stack.last.length.should == 2
		@app.get( :y )[:value].should == 1028
  end

	it "can handle an included module" do
    module Foo
      def state
        @state ||= 0
			end

			def inc
				@state = @state + 1
      end
    end

		class Tap
      include Foo
    end

		tap = Tap.new
    tap.state.should == 0
		tap.inc
		tap.state.should == 1
  end

	it "includes two modules: Stack and Symset" do end

	it "can evaluate a message expression (dot)" do
    skip
  end
end
