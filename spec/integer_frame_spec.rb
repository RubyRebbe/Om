require 'pp'
require "./models/quote.rb"
require "./models/app.rb"

describe "Integer Frame" do
  before :all do
    @app = App.new
  end

  it "can lexically recognize bang (!)" do
    q = Quote.new
		q.to_token( "!" ).should == { type: :bang, value: "!" }
  end

  it "App has a bang method" do
		@app.public_methods( false ).should include :bang
  end

	it "App.bang executes a string of ruby code against the App object" do
    @app.stack.should be_empty
    @app.bang "x = { type: :integer, value: 200 }; push x; push x"
		@app.stack.length.should == 2
  end

	it "bang in Om code executes a string of ruby code against the App object" do
		pp @app.stack
    code = '" push( stack[0][:value] + stack[1][:value] ) " !'
		q = Quote.new( code)
		@app.dot( q )
		@app.stack.length.should == 3
		@app.stack.last.should == 400
  end
end
