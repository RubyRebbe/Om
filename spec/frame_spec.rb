require 'pp'
require "./models/frame_stack.rb"
require "./models/quote.rb"
require "./models/app.rb"

describe "Frame" do
  it "can create an empty frame object" do
		fs = FrameStack.new
		f = fs.empty_frame
		f[:type].should == :frame
		f[:value].should == {}
  end

	it "can lexically recognize an empty frame - {}" do
    q = Quote.new
    t = q.to_token( "{}" )
		t[:type].should == :frame
		t[:value].should == {}
  end

	it "can push an empty frame object and a quote onto the stack" do
    code = "{} [ 0 ctr : ] "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )
		app.stack.map { |e| e[:type] }.should == [ :frame, :quote ]
  end

	it "can construct a frame object, sending a quote message to an empty frame" do
		code = "{} f : f # f # [ 0 ctr : ] . "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )
		app.stack.length.should == 1
		f  = app.stack.first
		f[:type].should == :frame
		f[:value].should == { ctr: { type: :integer, value: 0 } }
  end

	it "stack dup ( + ) works" do
		code = "{} +  [ 0 ctr : ] . "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )
		app.stack.length.should == 1
		f  = app.stack.first
		f[:type].should == :frame
		f[:value].should == { ctr: { type: :integer, value: 0 } }
  end

	it "can construct a counter object as a frame" do
		code = "{} +  [ 0 ctr : [ ctr # 1 add . ctr : ] inc : ] . counter : "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )

		counter = app.get( :counter )
		counter[:type].should == :frame
		counter[:value][:ctr][:value].should == 0

		code = "counter # [ inc # # ] ."
		q = Quote.new( code )
		app.dot( q )
		counter[:value][:ctr][:value].should == 1
  end


	it "can send an atomic message to a frame object via a re-write rule" do
    # re-write rule:
    # frame symbol . -->  frame [ symbol # ] .
    # now sending a message to frame looks identical
    # sending A message to a built in object like integer
		code = "{} +  [ 0 ctr : [ ctr # 1 add . ctr : ] inc :: ] . counter :: "	
		q = Quote.new( code )
		app = App.new
		app.dot( q )

		counter =  app.get( :counter )
		counter[:value][:value][:ctr][:value].should == 0

		code = "counter  inc  ."
		q = Quote.new( code )
		app.dot( q )
		counter[:value][:value][:ctr][:value].should == 1
  end
end
