require 'pp'
require "./models/om_modules.rb"
require "./models/frame_stack.rb"

class Frame
  include Symset

	def initialize
    symset
  end
end

describe FrameStack do
  before :all do
		@fs = FrameStack.new
  end

  it "is a stack of symbol table frames" do
    @fs.public_methods( true ).should include :push
    @fs.public_methods( true ).should include :pop
		
		@fs.frame_stack?.should == true
  end

	it "must initially have one symbol table frame" do
    @fs.stack.length.should == 1
  end

	it "acts like a symbol table, delegating to top symbol table frame" do
    @fs.public_methods( false ).should include :set
    @fs.public_methods( false ).should include :get
  end

	it "can set and get the base frame" do
    @fs.set( :foo, 1 )
		@fs.get( :foo ).should == 1
  end

	it "can push a frame and set and get there" do
		@fs.push( @fs.empty_frame )
    @fs.set( :foo, 2 )
		@fs.get( :foo ).should == 2

		pp @fs.stack
		 @fs.stack.map { |f| f[:value][:foo] }.should == [ 1, 2 ]
  end

	it "can pop a frame and be back to the base" do
    @fs.pop
		@fs.get( :foo ).should == 1
  end
end
