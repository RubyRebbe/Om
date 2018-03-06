require "./models/app.rb"
require "./models/quote.rb"

describe "Std Om" do
  before :all do
    @app = App.new
		@filename = "std.om"
		@code = "{} +  [ 0 ctr : [ ctr # 1 add . ctr : ] inc :: ] . counter :: "	
  end

	it "App has a method for loading - evaluating om code from a file" do
    @app.public_methods( false ).should include :eval_file
  end

	xit "can create the std.om file" do
    f = File.open( @filename, "w")
		f.write( @code )
		f.close

    f = File.open( @filename  )
		contents = f.read
		f.close
		contents.should == @code
  end

	it "App can load the std.om file" do
    @app.eval_file( @filename )
  end
	
	it "App can use the code in the std.om file" do
		ucode = "counter [ inc # ctr # ] .  "
		q = Quote.new( ucode )
		@app.dot( q )
		@app.stack.length.should == 1
		t = @app.stack.first
		t[:value].should == 1
  end

	xit "can remove the std.om file" do
    File::delete( @filename )
  end
end
