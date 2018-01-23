class SlotSet
  attr_accessor :slots

	def initialize
    @slots = 	{}
  end

	def empty?
    @slots.empty?
  end

	def put( k, v )
    @slots[k] = v
  end

	def get( k )
    @slots[k]
  end

	def eval( key )
    get( key ).call( slots )
  end
end

describe SlotSet do
  before :all do
    @slot_set = SlotSet.new
  end

	it "is initially empty" do
		@slot_set.should be_empty
  end

	it "is a possibly empty collection of slots" do true end

	it "a slot is a symbol key-value pair" do
		@slot_set.put( :state, 0 )
		@slot_set.get( :state ).should == 0
  end

	it "the value is either state or function" do 
		@slot_set.put( :inc , 
      lambda { |slots| slots[:state] = slots[:state] + 1 }
    )
	end

	it "a slot function has access to the state of the slot set" do  
		@slot_set.eval( :inc )
		@slot_set.get( :state ).should == 1
  end
end
