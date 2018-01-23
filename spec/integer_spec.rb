require  "./models/quote.rb"
require  "./models/app.rb"

describe "Integer" do
  before :all do
    @app = App.new
  end

	it "can add two integers" do
    @app.stack.clear
		quote = Quote.new( " 36 64 add . " )
		@app.dot( quote )
		@app.stack.length.should == 1
		top = @app.pop
		top[:type].should == :integer
		top[:value].should == 100
  end

	it "can negate an integer" do
    @app.stack.clear
		quote = Quote.new( " 64 neg . " )
		@app.dot( quote )
		@app.stack.length.should == 1
		top = @app.pop
		top[:type].should == :integer
		top[:value].should == -64
  end

	it "can multiply two  integers" do
    @app.stack.clear
		quote = Quote.new( " 64 64 mul . " )
		@app.dot( quote )
		@app.stack.length.should == 1
		top = @app.pop
		top[:type].should == :integer
		top[:value].should == 4096
  end

	it "can perform integer division" do
    @app.stack.clear
		quote = Quote.new( " 7 100 div . " )
		@app.dot( quote )
		@app.stack.length.should == 1
		top = @app.pop
		top[:type].should == :integer
		top[:value].should == 14
  end

	it "can do modulus" do
    @app.stack.clear
		quote = Quote.new( " 7 100 mod . " )
		@app.dot( quote )
		@app.stack.length.should == 1
		top = @app.pop
		top[:type].should == :integer
		top[:value].should == 2
  end

	it "can do equality comparison" do
    @app.stack.clear
		quote = Quote.new( " 7 100 eq . 237 237 eq . " )
		@app.dot( quote )
		@app.stack.length.should == 2
		@app.stack.map { |e| e[:value] }.should == [ 0, 1 ]
  end

	it "can do boolean negation" do
    @app.stack.clear
		quote = Quote.new( " 1 not . 0 not . " )
		@app.dot( quote )
		@app.stack.length.should == 2
		@app.stack.map { |e| e[:value] }.should == [ 0, 1 ]
  end

	it "can do boolean and" do
    @app.stack.clear
		quote = Quote.new( " 1 1 and . 1 0 and . 0 0 and ." )
		@app.dot( quote )
		@app.stack.map { |e| e[:value] }.should == [ 1, 0, 0 ]
  end

	it "can do boolean or" do
    @app.stack.clear
		quote = Quote.new( " 1 1 or . 1 0 or . 0 0 or ." )
		@app.dot( quote )
		@app.stack.map { |e| e[:value] }.should == [ 1, 1, 0 ]
  end
end
