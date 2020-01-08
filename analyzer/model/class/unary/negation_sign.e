note
	description: "Summary description for {NEGATION_SIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEGATION_SIGN
inherit
	EXPRESSION
create
	make
feature
	make
	do
		lte := "-"
	end
feature
	output: STRING
	do
		Result := "-"
	end


	feature
	accept ( v:VISITOR)
	do
		v.visit_negation (current)
	end
end

