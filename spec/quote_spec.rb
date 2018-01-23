require 'pp'
require "./models/quote.rb"

describe Quote do
  before :all do
    @q = Quote.new
  end

  it "can create an empty quote" do
		@q.should be_empty
  end

	describe "method to_token" do
  	it "recognize an erroneous token"  do
  		@q.to_token(  nil ).should == { type: :error, value: nil }
    end
  
  	it "recognize an open bracket"  do
  		@q.to_token( "[").should == { type: :open_quote, value: "[" }
    end
  
  	it "recognize a closing bracket"  do
  	  @q.to_token( "]").should == { type: :close_quote, value: "]" }
    end
  
  	it "recognize a binding" do
  	  @q.to_token( ":").should == { type: :binding, value: ":" }
    end
  
  	it "recognize an evaluation"  do
  	  @q.to_token( "#").should == { type: :eval, value: "#" }
    end
  
  	it "recognize a dot" do
  	  @q.to_token( ".").should == { type: :dot, value: "." }
    end
  
  	it "recognize a symbol" do
  	  @q.to_token( "foo").should == { type: :symbol, value: :foo }
    end
  
  	it "recognize an integer" do
  	  @q.to_token( "123").should == { type: :integer, value: 123 }
  	  @q.to_token( "-360").should == { type: :integer, value: -360 }
    end

  	it "recognize a quoted string" do
  	  @q.to_token( '"hello, world"' ).should == 
				{ type: :string, value: "hello, world" }
    end
  end

	describe "method to_tree" do
    it "can handle the empty string" do
      tl = @q.to_tokens( "" )
			tl.should be_empty
			tree = @q.to_tree( tl )
			tree[:type].should == :quote
			tree[:value].should be_empty
    end

		it "can handle a flat piece of code - no sub-quotes" do
      tl = @q.to_tokens( "360" )
			tree = @q.to_tree( tl )
			tree[:value].should == [ { type: :integer, value: 360 } ]

      tl = @q.to_tokens( "360 x" )
			tree = @q.to_tree( tl )
			tree[:value].map { |e| e[:value] }.should == [ 360, :x ]

      tl = @q.to_tokens( "360 x : " )
			tree = @q.to_tree( tl )
			tree[:value].map { |e| e[:value] }.should == [ 360, :x, ":" ]
    end

		it "can handle code with an empty sub-quote" do
      tl = @q.to_tokens( " [ ] " )
			tree = @q.to_tree( tl )
			tree[:value].should == [{:type=>:quote, :value=>[]}]
    end

		it "can handle code with a non-empty sub-quote" do
      tl = @q.to_tokens( " [ 360 x : ] " )
			tree = @q.to_tree( tl )
			tree[:value].length.should == 1
			e = tree[:value].first
			e[:type].should == :quote
			e[:value].map { |x| x[:value] }.should ==  [ 360, :x, ":" ]
    end
  end
end
