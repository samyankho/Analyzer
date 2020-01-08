note
	description: "Summary description for {TYPE_EVALUATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TYPE_EVALUATOR

inherit
	VISITOR

create
	make

feature
	type: EXPRESSION_TYPE

feature
	make
		do
			create {UNKNOWN_TYPE} type
			create tree.make(create {NIL_EXPRESSION}.make)
			create aoc.make_empty
		end
feature
	tree : EXPRESSION_TREE


feature
	replacetree(v : EXPRESSION_TREE)
	do
		tree := v.deep_twin
	end

	replaceaoc(v : ARRAY[CLASS_NAME])
	do
		aoc := v
	end


feature -- To Do: Implement Commands for visiting composite structure
	visit_integer_constant (e: INTEGER_CONSTANT)
		do
			type:= create {INTEGER_TYPE}.default_create
		end

	visit_boolean_constant (e: BOOLEAN_CONSTANT)
		do
			type:= create {BOOLEAN_TYPE}.default_create
		end
	visit_class_expression( e : CLASS_EXPRESSION)
		do
			type := create {CLASS_TYPE}.make (e.classs)
		end


	visit_addition (e: ADDITION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end


	visit_subtraction (e: SUBTRACTION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_multiplication (e: MULTIPLICATION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_division (e: DIVISION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_modulo (e: MODULO)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_equals (e: EQUALS)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {INTEGER_TYPE}.default_create
			elseif
				attached {BOOLEAN_TYPE} cal_left.type and attached {BOOLEAN_TYPE} cal_right.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			elseif
				attached {CLASS_TYPE} cal_left.type and attached {CLASS_TYPE} cal_right.type
			then
				if cal_left.type.classs.out ~ cal_right.type.classs.out  then
					type:= create {CLASS_TYPE}.default_create
					type.replace(cal_left.type.classs.out)
				else
					type:= create {UNKNOWN_TYPE}.default_create
				end
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_negation (e: NEGATION_SIGN)
		local
			calculator: TYPE_EVALUATOR
		do
			create calculator.make
			tree.righttree.accept (calculator)
			if
				attached {BOOLEAN_TYPE} calculator.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end


	visit_greater_than (e: GREATERTHAN)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end


	visit_less_than (e: LESSTHAN)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {INTEGER_TYPE} cal_left.type and attached {INTEGER_TYPE} cal_right.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end


	visit_conjunction (e: CONJUNCTION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {BOOLEAN_TYPE} cal_left.type and attached {BOOLEAN_TYPE} cal_right.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_disjunction (e: DISJUNCTION)
		local
			cal_left, cal_right: TYPE_EVALUATOR
		do
			create cal_left.make
			create cal_right.make
			tree.lefttree.accept (cal_left)
			tree.righttree.accept (cal_right)
			if
				attached {BOOLEAN_TYPE} cal_left.type and attached {BOOLEAN_TYPE} cal_right.type
			then
				type:= create {BOOLEAN_TYPE}.default_create
			else
				type:= create {UNKNOWN_TYPE}.default_create
			end
		end


	visit_logical_negation (e: LOGICAL_NEGATION)
		local
			calculator: TYPE_EVALUATOR
		do
			create calculator.make
			tree.righttree.accept (calculator)
			if
				attached {BOOLEAN_TYPE} calculator.type
			then
				type := create {BOOLEAN_TYPE}.default_create
			else
				type := create {UNKNOWN_TYPE}.default_create
			end
		end

	visit_call_chain(e : CALLCHAIN)
		local
			aocopy : ARRAY[CLASS_NAME]
			chain : ARRAY[STRING]
			currentclass : STRING
			currentclassindex : INTEGER
			currentfq : INTEGER
			currentfqweizhi : INTEGER
			worked : BOOLEAN
			ii : INTEGER
		do
			aocopy := aoc.deep_twin
			chain := e.list.deep_twin
			currentclass := e.quanjia.c
			from
				ii := 1
			until
				ii > aoc.count
			loop
				if aoc[ii].getname ~ currentclass then
					currentclassindex := ii
				end
			end
			currentfq := e.quanjia.fq
			currentfqweizhi := e.quanjia.fqweizhi
			worked := False
			if chain.count = 1 then
				if chain[1].out ~ "Result" then
					if currentfq = 0 then
						worked := true
						type := create {UNKNOWN_TYPE}.default_create
					else
					end
				end
			end
		end


feature
	aoc : ARRAY[CLASS_NAME]

end
