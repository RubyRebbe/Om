Feature: Om interpreter
	as a programmer in the om language
  I want to be able to interpret an om program
	in order to run, debug and compute with it

	Scenario: the empty string
    Given the empry string ""
		When I run the interpreter
		Then I see no change in state of the om App object
