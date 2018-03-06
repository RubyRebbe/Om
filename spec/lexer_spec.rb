require 'pp'
require 'byebug'
require "./models/lexer.rb"

describe Lexer do
  before :all do
    @lexer = Lexer.new
		@ws = "    \t  \n    "
  end

  it "provides lexical tokenization service for the Om language" do
    @lexer.should_not be_nil
  end

	it "has a method to_tokens which returns a sequence of tokens, possibly empty" do
		@lexer.to_tokens( "" ).class.should == Array
		@lexer.to_tokens( "" ).should be_empty
  end

  it "can recognize white space" do
		@lexer.public_methods( false ).should include :whitespace
		@lexer.whitespace( @ws ).should == @ws
		@lexer.whitespace( "foobar" ).should == nil
  end

	it "eliminates white space from the token stream" do
		@lexer.to_tokens( @ws ).should be_empty
  end

	it "can recognize a reserved word" do
		@lexer.public_methods( false ).should include :reserved
		@lexer.to_tokens( @ws + "["  ).length.should == 1
		@lexer.to_tokens( "[" + @ws ).length.should == 1
		@lexer.to_tokens( @ws + "[" + @ws ).length.should == 1
  end

	it "can convert a reserved word into a token" do
		t = @lexer.to_tokens( @ws + "[" + @ws ).first
		t.class.should == Hash
		t.keys.should == [ :type, :value ]
  end

	it "has a list in support of Om reserved words" do
    @lexer.public_methods(false).should include :reserved_words
		@lexer.reserved_words.class.should == Array
		@lexer.reserved_words.each { |e| e.keys.should == [ :type, :value ] }
  end

	it "has a method for recognizing an Om reserved word" do
    @lexer.public_methods(false).should include :reserved_word
  end

	it "can recognize all the  reserved words of the Om language" do
    @lexer.reserved_words.each { |e|
      code = e[:value]
		  @lexer.to_tokens( code ).length.should == 1
		  t = @lexer.to_tokens( code ).first
			if t[:type] == :frame then
        t[:value].should == {}
      else
			  t.should == e
      end
    }
  end

	it "can recognize a integer" do
    @lexer.public_methods(false).should include :integer
		@lexer.integer( "369" ).should == { type: :integer, value: 369 }
		@lexer.to_tokens( "369" ).length.should == 1
		t = @lexer.to_tokens( "     369    " ).first
		t[:value].should == 369

		@lexer.to_tokens( "     369 -457  " ).map { |e| e[:value] }.should ==
      [ 369, -457 ]
  end

	it "can recognize a symbol" do
		@lexer.symbol( "foo" ).should == { type: :symbol, value: :foo }
		@lexer.to_tokens( "  369 -457  foo :  " ).map { |e| e[:value] }.should ==
      [ 369, -457, :foo, ":" ]
  end

	it "can recognize a quoted string" do
    @lexer.public_methods(false).should include :string
		s =  '"now   is \n \t the time ."'
		t =  @lexer.string( s )
		t[:type].should == :string
		t[:value].should == s[1..-2]

		@lexer.to_tokens( '"puts x" ruby :' ).map { |e| e[:type] }.should ==
      [ :string, :symbol, :binding ]
	end
end
