note
	description: "Summary description for {DISJUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DISJUNCTION
inherit
	EXPRESSION

create
	make_oror
feature
	make_oror
	do
		lte := "||"
	end
	output : STRING
	do
		Result := lte
	end
	feature
	accept ( v:VISITOR)
	do
		v.visit_disjunction (current)
	end
end
