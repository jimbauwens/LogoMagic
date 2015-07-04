infix = {}									-- Infix operators

infix["+"]	= {pr = 1}
infix["+"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("+", a, b) end
	return tostring( aa + bb)
end

infix["-"]	= {pr = 1}
infix["-"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("-", a, b) end
	return tostring( aa - bb)
end

infix["/"]	= {pr = 2}
infix["/"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("/", a, b) end
	return tostring( aa / bb)
end

infix["*"]	= {pr = 2}
infix["*"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("*", a, b) end
	return tostring( aa * bb)
end

infix["<"]	= {pr = 4}
infix["<"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("<", a, b) end
	return tostring(aa < bb)
end

infix[">"]	= {pr = 4}
infix[">"].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input(">", a, b) end
	return tostring(aa > bb)
end

infix["="]	= {pr = 4}
infix["="].func = function (a,b)
	return tostring(a == b)
end

infix["<>"]	= {pr = 4}
infix["<>"].func = function (a,b)
	return tostring(a ~= b)
end

infix[">="]	= {pr = 4}
infix[">="].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input(">=", a, b) end
	return tostring(aa >= bb)
end

infix["<="]	= {pr = 4}
infix["<="].func = function (a,b)
	local	aa	=	tonumber(a)
	local	bb	=	tonumber(b)
	if not aa or not bb then logo_bad_input("<=", a, b) end
	return tostring(aa <= bb)
end


------------------------------------------
--         PARSE INFIX OPERATORS        --
------------------------------------------

function compute_infix(d, stack, endl, pre) 
	local last = ""
	local rpn = {}
	local operstack = {}
	local l=0
	local dt = ""
	local pretoken	= {}
	pretoken[d.pos]	= pre
	
	while d.pos <= #d.token do
		token	=	pretoken[d.pos] or d.token[d.pos]
		if token == "-" and l==0 then
			table.insert(rpn, "0")
			table.insert(operstack, "-")
		elseif infix[token] then
			l=0
			last = operstack[#operstack]
			while last and (infix[last].pr >= infix[token].pr) do
				table.insert(rpn, table.remove(operstack))
				last = operstack[#operstack]
			end
			
			table.insert(operstack, token)
		elseif token == ")" then
			d.pos = d.pos + 1
			break
		elseif l == 0 then
			dt = data_type(d, stack, pre)
			if dt then
				table.insert(rpn, dt)
				l=1		
			else
				table.insert(rpn, parse_token(d, stack, endl, true))
			end
			
			l = 1
		else 
			break
		end
		
		pre	=	nil
		d.pos = d.pos + 1
	end
	
	for i=1, #operstack do
		last = table.remove(operstack)
		table.insert(rpn, last)
	end

	d.pos = d.pos - 1
	local solved = rpn_solve(rpn)
	--print(solved)
	return solved
end

----------------------------
--       SOLVE RPN        --
----------------------------

function rpn_solve(rpn, pos)
	pos = pos or #rpn
	--print(unpack(rpn))
	local operator	=	rpn[pos]
	
	pos = pos -1
	local input1	=	rpn[pos]
	if infix[input1] then
		input1, pos=rpn_solve(rpn, pos)
	end
	
	pos = pos -1
	local input2	=	rpn[pos]
	if infix[input2] then
		input2, pos=rpn_solve(rpn,pos)
	end	
	if not input1 or not input2 then logo_error("not enough inputs to " .. operator) end
	return infix[operator].func(input2, input1), pos
end
