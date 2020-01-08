note
	description: "Summary description for {CONJUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONJUNCTION
inherit
--	EXPRESSION_TREE
	EXPRESSION


create
--	make_andand
	make
feature
--	make_andand
--	do
--		make_expression_tree(CURRENT)
--	end
	make
	do
		lte := "&&"
	end
	output : STRING
	do
		Result := lte
	end


feature
	accept ( v:VISITOR)
	do
		v.visit_conjunction (current)
	end
end
