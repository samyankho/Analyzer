note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create aoc.make_empty
			aoc.compare_objects
			i := 0
			statusbool := TRUE
			create statusmessage.make_empty
			in_assignment_instruction_specified := False
			create current_added_name.default_create
			create current_fea.make_empty
			create current_cla.make_empty
			create current_varna.make_empty
			create {INPUTING_EXPRESSION} current_varex.make
			current_aoq := FALSE
			typepandgeneralcode := FALSE
			create typepandgeneralcodeprintout.make_empty
			currentexpressionweizhi := 0
			currentfqweizhi := 0

		end

feature -- model attributes
	s : STRING
	i : INTEGER
	aoc: ARRAY[CLASS_NAME]
	statusbool: BOOLEAN
	in_assignment_instruction_specified : BOOLEAN
	statusmessage : STRING
	current_added_name: TUPLE[STRING,STRING]
	current_fea: STRING
	current_cla: STRING
	current_varex : EXPRESSION
	current_varna : STRING
	current_aoq : BOOLEAN
	typepandgeneralcode: BOOLEAN
	typepandgeneralcodeprintout : STRING
	currentfqweizhi : INTEGER
	currentexpressionweizhi : INTEGER



feature -- model operations





	setuperror(str : STRING)
		do
			statusbool := False
			statusmessage := str
		end

	existing_class(c:STRING):BOOLEAN
		do
			result :=
			across
				aoc is cn
			some
			 	cn.getname ~ c
			end
		end

	existing_var(var : STRING; c : STRING):BOOLEAN
		do
			result := False
			from
				i := 1
			until
				i > aoc.count
			loop
				if (aoc[i].getname ~ c) then
					result := across aoc[i].aov is a some a.getname ~ var  end
					i := aoc.count + 1
				end
				i := i+1
			end
		end

	fea_type_not_exist(cn:STRING ;fn:STRING): STRING
		do
			create result.make_empty
			across
			aoc	 is c
			loop
				if
					c.getname ~ cn
				then
								if
							across
								c.aoq is qn
							some
								qn.getname ~ fn
							end
						then
						elseif
							across
								c.aof is f
							some
								f.getname ~ fn
							end
						then
						else
							result.append(fn)
						end
				end
			end
		end

	att_type_not_exist(ft:STRING):STRING
		do
			create result.make_empty
			if
			across
				aoc is cn
			some
				cn.getname ~ ft
			end
			then
			elseif
				ft ~ "INTEGER" or ft ~ "BOOLEAN"
			then
			else
				result.append(ft)
			end
		end

	para_type_not_exist(ps:ARRAY[TUPLE[pn: STRING; ft: STRING]]): STRING
		do
			create result.make_empty
			ps.compare_objects
			across
				ps is p
			loop
				if (p.ft ~ "INTEGER") or (p.ft ~ "BOOLEAN") then
				elseif (across aoc is a some a.getname ~ p.ft end) then
				else
					result.append (p.ft + ", ")
				end

			end

			if
				not result.is_empty
			then
				result.remove_tail (2)
			end
		end

	existing_feature(cn:STRING; fn:STRING):BOOLEAN
		do

			across
				aoc is c
			loop
				if c.getname ~ cn then
					result:=
					across
						c.aov is att
					some
						att.getname ~ fn
					end
				end
			end
		end

	duplicatecheck(ps: ARRAY[TUPLE[pn: STRING; ft: STRING]]):STRING
	local
		exitsname : ARRAY[STRING]
	do
		create exitsname.make_empty
		create Result.make_empty
		exitsname.compare_objects
		across ps is tupao loop

		if(exitsname.has (tupao.pn))then
			Result.append(tupao.pn + ", ")
		else
			exitsname.force (tupao.pn, exitsname.count + 1)
		end
		end

		if not Result.is_empty then
			Result.remove_tail (2)
		end
	end


	conflict_cpn(ps: ARRAY[TUPLE[pn: STRING; ft: STRING]]): STRING
		local
			classname : ARRAY[STRING]
		do
			classname := <<"INTEGER","Result","BOOLEAN","STRING","ARRAY","LINKED_LIST","ARRAYED_LIST","HASH_TABLE">>
			create Result.make_empty
			across
				1|..| ps.count is j
			loop
				across
					aoc is c
				loop
					if c.getname ~ ps[j].pn then

					Result.append (ps[j].pn + ", ")

					end

				end
				if across classname is d some d ~ ps[j].pn end then
					Result.append (ps[j].pn + ", ")
				end
			end
			if not Result.is_empty then
				Result.remove_tail(2)
			end
		end



	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	accept(v: VISITOR)
		do


		end



	type_check
		-- Is the specified program type-correct?
--		local
--			typecheck : TYPE_CHECK
		local
			temp : BOOLEAN
			indexcom : INTEGER
			indexque : INTEGER
			j : LINKED_LIST[INTEGER]
			a : STRING
			kk : EXPRESSION_TREE
			qq : EXPRESSION_TREE
			ii : INTEGER
			jj : CLASS_EXPRESSION
		do
			typepandgeneralcode := True
			create kk.make (create {NIL_EXPRESSION}.make)
			create qq.make (create {NIL_EXPRESSION}.make)
			create a.make_empty
			across aoc is clas loop
				temp := TRUE
				j := clas.shunxu.deep_twin
				indexcom := 1
				indexque := 1
				a.make_empty
				from
					j.start
				until
					j.after
				loop
					kk.make (create {NIL_EXPRESSION}.make)
					qq.make (create {NIL_EXPRESSION}.make)
					create jj.make ("empty")
					if j.item = 0 then
						across clas.aof[indexcom].getexp is exp loop
--							if not typecheck_helper(exp.tree) then
--								a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
--								temp := false
--							end
							from
								ii := 1
							until
								ii > clas.aov.count
							loop
								if (exp.name ~ clas.aov[ii].pn) then
									if clas.aov[ii].pt.out ~ "INTEGER" then
										kk.make (create {INTEGER_CONSTANT}.make (0))
										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									elseif clas.aov[ii].pt.out ~ "BOOLEAN" then
										kk.make (create {BOOLEAN_CONSTANT}.make (FALSE))
										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									elseif across aoc is cl some cl.getname.out ~ clas.aov[ii].pt.out end then
											jj.make (exp.name)
												across aoc is cl loop
												if cl.getname.out ~ clas.aov[ii].pt.out then
													jj.replace (cl.getname.out)
												end end
												kk.make (jj)
										kk.make (create {CLASS_EXPRESSION}.make (exp.name))
										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									end
								end
								ii := ii + 1
							end

							if attached {NIL_EXPRESSION} qq.item then
								from
									ii := 0
								until
									ii > clas.aof[indexcom].aov.count
								loop
									if (exp.name ~ clas.aof[indexcom].aov[ii].pn) then
										if clas.aof[indexcom].aov[ii].pt.out ~ "INTEGER" then
											kk.make (create {INTEGER_CONSTANT}.make (0))
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aof[indexcom].aov.count
										elseif clas.aof[indexcom].aov[ii].pt.out ~ "BOOLEAN" then
											kk.make (create {BOOLEAN_CONSTANT}.make (FALSE))
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aof[indexcom].aov.count
										elseif across aoc is cl some cl.getname.out ~ clas.aof[indexcom].aov[ii].pt.out end then
											jj.make (exp.name)
												across aoc is cl loop
												if cl.getname.out ~ clas.aof[indexcom].aov[ii].pt.out then
													jj.replace (cl.getname.out)
												end end
												kk.make (jj)
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aof[indexcom].aov.count
										end
									end
									ii := ii + 1
								end
							end
						end
						indexcom := indexcom + 1






					elseif j.item = 1 then
						across clas.aoq[indexque].getexp is exp loop
--							a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
--								temp := false
--							end

							if exp.name ~ "Result" then
								if clas.aoq[indexque].rt.out ~ "INTEGER" then
									kk.make (create {INTEGER_CONSTANT}.make (0))
									qq.make_expression_tree (create {EQUALS}.make_equals)
									qq.changeleft (kk)
									qq.changeright (exp.tree.deep_twin)
									if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
								elseif clas.aoq[indexque].rt.out ~ "BOOLEAN" then

									kk.make (create {BOOLEAN_CONSTANT}.make (False))
									qq.make_expression_tree (create {EQUALS}.make_equals)
									qq.changeleft (kk)
									qq.changeright (exp.tree.deep_twin)
									if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
								elseif across aoc is cl some cl.getname.out ~ clas.aoq[indexque].rt.out end then
									jj.make (exp.name)
									across aoc is cl loop
									if cl.getname.out ~ clas.aoq[indexque].rt.out then
										jj.replace (cl.getname.out)
									end end
									kk.make (jj)
									qq.make_expression_tree (create {EQUALS}.make_equals)
									qq.changeleft (kk)
									qq.changeright (exp.tree.deep_twin)
									if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
									end

								end

							else
							from
								ii := 1
							until
								ii > clas.aov.count
							loop
								if (exp.name ~ clas.aov[ii].pn) then
									if clas.aov[ii].pt.out ~ "INTEGER" then
										kk.make (create {INTEGER_CONSTANT}.make (0))
										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									elseif clas.aov[ii].pt.out ~ "BOOLEAN" then
										kk.make (create {BOOLEAN_CONSTANT}.make (FALSE))
										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									elseif across aoc is cl some cl.getname.out ~ clas.aov[ii].pt.out end then
										jj.make (exp.name)
										across aoc is cl loop
										if cl.getname.out ~ clas.aov[ii].pt.out then
											jj.replace (cl.getname.out)
										end end
										kk.make (jj)

										qq.make_expression_tree (create {EQUALS}.make_equals)
										qq.changeleft (kk)
										qq.changeright (exp.tree.deep_twin)
										if not typecheck_helper(qq) then
											a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
											temp := false
										end
										ii := clas.aov.count
									end
								end
								ii := ii + 1
							end

							if attached {NIL_EXPRESSION} qq.item then
								from
									ii := 0
								until
									ii > clas.aoq[indexcom].aov.count
								loop
									if (exp.name ~ clas.aoq[indexcom].aov[ii].pn) then
										if clas.aof[indexcom].aov[ii].pt.out ~ "INTEGER" then
											kk.make (create {INTEGER_CONSTANT}.make (0))
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aof[indexcom].aov.count
										elseif clas.aoq[indexcom].aov[ii].pt.out ~ "BOOLEAN" then
											kk.make (create {BOOLEAN_CONSTANT}.make (FALSE))
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aoq[indexcom].aov.count
										elseif across aoc is cl some cl.getname.out ~ clas.aoq[indexcom].aov[ii].pt.out end then
											jj.make (exp.name)
											across aoc is cl loop
											if cl.getname.out ~ clas.aoq[indexcom].aov[ii].pt.out then
												jj.replace (cl.getname.out)
											end end
											kk.make (jj)
											qq.make_expression_tree (create {EQUALS}.make_equals)
											qq.changeleft (kk)
											qq.changeright (exp.tree.deep_twin)
											if not typecheck_helper(qq) then
												a.append ("    " + exp.name + " = " + exp.tree.output + " in routine " + clas.aof[indexcom].getname + " is not type-correct." + "%N")
												temp := false
											end
											ii := clas.aof[indexcom].aov.count
										end
									end
									ii := ii + 1
								end
							end
						end
						end







						indexque := indexque + 1








					end
					j.forth
				end
				if temp then
					typepandgeneralcodeprintout.append ("  class " + clas.getname + " is type-correct." + "%N")
				else
					typepandgeneralcodeprintout.append ("  class " + clas.getname + " is not type-correct." + "%N")
					typepandgeneralcodeprintout.append (a)
				end

			end
			typepandgeneralcodeprintout.remove_tail (2)
		end

	typecheck_helper(tree : EXPRESSION_TREE):BOOLEAN
		local
			typecheck : TYPE_CHECK
			typecheck2 : TYPE_CHECK
		do
			result := true
			create typecheck.make
			if not tree.does_left_child_have_children and not tree.does_right_child_have_children then
				typecheck.make
				typecheck.replaceaoc(aoc.deep_twin)
				tree.accept (typecheck)
				result := typecheck.type_correct
			end
			if tree.does_left_child_have_children and result then
				typecheck.make
				typecheck.replaceaoc(aoc.deep_twin)
				tree.accept (typecheck)
				result := typecheck.type_correct and typecheck_helper (tree.lefttree)
			end
			if tree.does_right_child_have_children and result then
				typecheck.make
				typecheck.replaceaoc(aoc.deep_twin)
				tree.accept (typecheck)
				result := typecheck.type_correct and typecheck_helper (tree.righttree)
			end
		end

	generate_java_code
		-- For the program specified, generate Java-like code.
		do

		end

	add_class(cn: STRING)
		-- Add a new class with name ‘cn‘.
	require
		not existing_class(cn)
		local
			c : CLASS_NAME
		do
			create c.make (cn)
			aoc.force (c, aoc.count + 1)
	ensure
		added: existing_class(cn)
		end


	add_attribute(cn: STRING; -- context class
	fn: STRING; -- name of attribute
	ft: STRING -- attribute type
	)
	-- Add to class ‘cn‘ a new attribute ‘fn‘ with type ‘ft‘.
	require
		existing_var: not existing_var(fn,ft)
		existing_class: existing_class (cn)
		existing_feature_name: not existing_feature (cn,fn)
		existing_att_type: att_type_not_exist(ft).is_empty
	local
		att: VAR_NAME
		do
			create att.make (fn, ft)
			across
				aoc is c
			loop
				if
					c.getname ~ cn
				then
					c.aov.force(att, c.aov.count+1)
				end
			end
		ensure
			added: existing_var(fn,ft)
		end


	add_command(
	cn: STRING; -- context class
	fn: STRING; --feature nam -- name of command
	ps: ARRAY[TUPLE[name : STRING;  type: STRING]] -- parameters
	)
	-- Add to class ‘cn‘ a new command ‘fn‘ with a list of parameters ‘ps‘.
	-- Each parameter is a tuple with parameter name ‘pn‘ and type ‘ft‘.
	require
		assigning: not in_assignment_instruction_specified
		existing_feature: not existing_feature (cn,fn)
		existing_class: existing_class (cn)
		conflict_conflict_paraname: conflict_cpn(ps).is_empty
		no_duplicate: duplicatecheck(ps).is_empty
		para_type_not_exis:para_type_not_exist(ps).is_empty
	local
		fea: COMMAND_NAME
		do
			create fea.make(fn)


			-- to input the paracter into feature ( command)
			across ps is pa loop
			fea.inputpara (pa.name, pa.type)
			end

			-- to find the match Class name and input the command into the class
			across aoc is c loop
			if c.getname ~ cn then
				c.aof.force(fea,c.aof.count+1)
				c.shunxu.force(0)
			end
			end
		ensure
			added: existing_feature (cn,fn)
		end



	add_query(
	cn: STRING; -- context class
	fn: STRING; -- name of query
	ps: ARRAY[TUPLE[name : STRING;  type: STRING]]; -- parameters
	rt: STRING -- return type
	)
	-- Add to class ‘cn‘ a new query ‘fn‘ with a list of parameters ‘ps‘
	-- and return type ‘rt‘.
	-- Each parameter is a tuple with parameter name ‘pn‘ and type ‘ft‘.
	require
		return_type_notexist: att_type_not_exist(rt).is_empty
		assigning: not in_assignment_instruction_specified
		existing_feature: not existing_feature (cn,fn)
		existing_class: existing_class (cn)
		conflict_conflict_paraname: conflict_cpn(ps).is_empty
		no_duplicate: duplicatecheck(ps).is_empty
		para_type_not_exis:para_type_not_exist(ps).is_empty
	local
		qn: QUERY_NAME
		do
			create qn.make (fn, rt)
			-- to input the paracter into feature ( query)
			across ps is pa loop
			qn.inputpara (pa.name, pa.type)
			end
			--to add the query into class
			across
				aoc is c
			loop
				if
					c.getname ~ cn
				then
					c.aoq.force(qn, c.aoq.count+1)
					c.shunxu.force(1)
				end
			end
		ensure
			added: existing_feature (cn,fn)
		end




	add_assignment_instruction (cn: STRING; fn: STRING; n: STRING)
	-- Assign to variable with name ‘n‘, in the context of routine ‘fn‘ in class ‘cn‘.
	-- Here ‘n‘ should either be ‘																			‘ (in the context of a query),
	-- or an attribute name in the current class.
	    local
		q: INPUTING_EXPRESSION
		do
			create q.make
			across
				aoc is c
			loop
				if
					c.getname ~ cn
				then
					across
						c.aof is f
					loop
						if
							f.getname ~ fn
						then
							f.add_variable(n,q)
							in_assignment_instruction_specified := true
							current_fea:= fn
							current_cla:= cn
							current_varex:= q
							current_varna := n
							current_aoq := False
						end
					end

					across
						c.aoq is f
					loop
						if
							f.getname ~ fn
						then
							f.add_variable(n,q)
							in_assignment_instruction_specified := true
							current_fea:= fn
							current_cla:= cn
							current_varex:= q
							current_varna := n
							current_aoq := True
						end
					end
				end
			end

		end


	-- Below are all events related to specifying expressions for Assignment RHS.

	get_current_tuple: TUPLE[name : STRING; tree : EXPRESSION_TREE]
		local
			o,j,k : INTEGER
		do
			create Result.default_create
			from
				o := 1
			until
				o > aoc.count
			loop
				if aoc[o].getname ~ current_cla then
					if current_aoq then
						from
							j := 1
						until
							j > aoc[o].aoq.count
						loop
							if aoc[o].aoq[j].getname ~ current_fea then
								currentfqweizhi := j.deep_twin
								currentexpressionweizhi := aoc[o].aoq[j].getexp.count.deep_twin
								Result := aoc[o].aoq[j].getexp[aoc[o].aoq[j].getexp.count]
								j := aoc[o].aoq.count + 1
							end
							j := j + 1
						end
					else
						from
							k := 1
						until
							k > aoc[o].aof.count
						loop
							if aoc[o].aof[k].getname ~ current_fea then
								currentfqweizhi := k.deep_twin
								currentexpressionweizhi := aoc[o].aof[k].getexp.count.deep_twin
								Result := aoc[o].aof[k].getexp[aoc[o].aof[k].getexp.count]
								k := aoc[o].aof.count + 1
							end
							k := k + 1
						end
					end
					o := aoc.count + 1
				end

				o := o + 1
			end
		end

	input_into_current_expression_tree(inputitem : EXPRESSION_TREE)
			local
				o,j,k : INTEGER
			do
				from
					o := 1
				until
					o > aoc.count
				loop
					if aoc[o].getname ~ current_cla then
						if current_aoq then
							from
								j := 1
							until
								j > aoc[o].aoq.count
							loop
								if aoc[o].aoq[j].getname ~ current_fea then
									aoc[o].aoq[j].changelasttree(inputitem)
									j := aoc[o].aoq.count + 1
								end
								j := j + 1
							end
						else
							from
								k := 1
							until
								k > aoc[o].aof.count
							loop
								if aoc[o].aof[k].getname ~ current_fea then
									aoc[o].aof[k].changelasttree(inputitem)
									j := aoc[o].aof.count + 1
								end
								k := k + 1
							end
						end
						o := aoc.count
					end

					o := o + 1
				end
			end



	add_call_chain(chain: ARRAY[STRING])
	-- Add a chain of calls to attributes (not queries or commands).
	-- Events of users adding constants
	local
		b: CALLCHAIN
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			tree := current.get_current_tuple.tree
			if current.current_aoq then
				create b.make_callchain (chain, [current.current_cla,1,currentfqweizhi,currentexpressionweizhi])
			else
				create b.make_callchain (chain, [current.current_cla,0,currentfqweizhi,currentexpressionweizhi])
			end
			create bb.make (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			create dd.make (create {NIL_EXPRESSION}.make)

			if tree.replaceb (cc,bb) then
				if not tree.replaceb (dd, cc) then
					in_assignment_instruction_specified := false
				end
			end
			current.input_into_current_expression_tree (tree)
	end





	bool_value (c: BOOLEAN)
	require
		assigning: not in_assignment_instruction_specified
		local
			b: BOOLEAN_CONSTANT
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make (c)
			create bb.make (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			create dd.make (create {NIL_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
				if not tree.replaceb (dd, cc) then
					in_assignment_instruction_specified := false
				end
			end
			current.input_into_current_expression_tree (tree)
		end

	int_value (c: INTEGER)
	-- Events of users adding binary arithmetic operations
	require
		assigning: not in_assignment_instruction_specified
	local
		b: INTEGER_CONSTANT
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make (c)
			create bb.make (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			create dd.make (create {NIL_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
				if not tree.replaceb (dd, cc) then
					in_assignment_instruction_specified := false
				end
			end
			current.input_into_current_expression_tree (tree)
	end

	addition
	require
		assigning: not in_assignment_instruction_specified
	local
		b: ADDITION
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)
	end

	subtraction
	require
		assigning: not in_assignment_instruction_specified
	local
		b:SUBTRACTION
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make_subtraction
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


	end


	multiplication
	require
		assigning: not in_assignment_instruction_specified
	local
		b:MULTIPLICATION
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make_multiplication
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


	end


	quotient
	require
		assigning: not in_assignment_instruction_specified
	local
		b:DIVISION
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make_division
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


	end

	modulo
	require
		assigning: not in_assignment_instruction_specified
		local
			b:MODULO
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make_modulo
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)
		end



	-- Events of users adding binary logical operations
	conjunction
	require
		assigning: not in_assignment_instruction_specified
		local
			b:CONJUNCTION
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)
		end

	disjunction
	-- Events of users adding binary relational operations
	require
		assigning: not in_assignment_instruction_specified
		local
			b:DISJUNCTION
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make_oror
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


		end

	equals
	require
		assigning: not in_assignment_instruction_specified
		local
			b:EQUALS
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make_equals
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


		end

	greater_than
	require
		assigning: not in_assignment_instruction_specified
		local
			b:GREATERTHAN
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make_greaterthan
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)
		end

	less_than
	-- Events of users adding unary numerical or logical operations
	require
		assigning: not in_assignment_instruction_specified
	local
		b:LESSTHAN
		bb: EXPRESSION_TREE
		cc: EXPRESSION_TREE
		dd: EXPRESSION_TREE
		tree : EXPRESSION_TREE
	do
			create b.make_lessthan
			create bb.make_expression_tree (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


	end

	numerical_negation
	require
		assigning: not in_assignment_instruction_specified
		local
			b:NEGATION_SIGN
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make
			create bb.make_unary (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)


		end

	logical_negation
	require
		assigning: not in_assignment_instruction_specified
		local
			b:LOGICAL_NEGATION
			bb: EXPRESSION_TREE
			cc: EXPRESSION_TREE
			dd: EXPRESSION_TREE
			tree : EXPRESSION_TREE
		do
			create b.make
			create bb.make_unary (b)
			create cc.make (create {INPUTING_EXPRESSION}.make)
			tree := current.get_current_tuple.tree
			if tree.replaceb (cc,bb) then
			end
			current.input_into_current_expression_tree (tree)
		end



feature -- queries
	out : STRING
		do
			if typepandgeneralcode then
				typepandgeneralcode := false
				result := typepandgeneralcodeprintout.out
				typepandgeneralcodeprintout.make_empty
			else
			create Result.make_from_string ("  ")
			Result.append("Status: ")
			if not statusbool then
				Result.append("Error ("+statusmessage+").%N")
				statusmessage.make_empty
				statusbool := True
			else
				Result.append ("OK.%N")
			end

			Result.append ("  Number of classes being specified: " + aoc.count.out)
			across aoc is a loop Result.append(a.output) end

			if in_assignment_instruction_specified then
				Result.append("%N"+"  Routine currently being implemented: {"+ current_cla+"}."+current_fea)
				Result.append("%N"+"  Assignment being specified: "+ get_current_tuple.name +" := " + get_current_tuple.tree.output )
			end
			end
		end
end




