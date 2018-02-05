require "./models/om_modules.rb"

class Frame
  include Symset

	def initialize
    symset
  end

	def keys
    symset.keys
  end

	def length
    symset.length
  end

	def empty?
    symset.empty?
  end
end
