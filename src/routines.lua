---------------------------------------------------------------------------------------------------
------------------------------------------ Logo Routines ------------------------------------------
---------------------------------------------------------------------------------------------------

subroutine = {}

function logo_bad_input(fname, inp1, inp2)
	local err	=	fname .. " doesn\'t like " .. (inp2 and list_to_string(inp1, true) .. " or " .. list_to_string(inp2, true) or list_to_string(inp1, true)) .. " as input"
	logo_error(err)
end

--------------------------------------
--           Math Routines          --
--------------------------------------

subroutine.sum		=	{p=2, e=true}
subroutine.sum.func	=	function (_, ...)
	local output = 0
	local number = 0
	for i,p in pairs({...}) do
		number = tonumber(p)
		if number then
			output = output + number
		else
			logo_bad_input("sum", p)
		end
	end
	
	return tostring(output)
end

subroutine.product		=	{p=2, e=true}
subroutine.product.func	=	function (_, ...)
	local output = 0
	local number = 0
	for i,p in pairs({...}) do
		number = tonumber(p)
		if number then
			output = output * number
		else
			logo_bad_input("product", p)
		end
	end
	
	return tostring(output)
end

subroutine.difference		=	{p=2}
subroutine.difference.func	=	function (_, n1, n2)
	if tonumber(n1) and tonumber(n2) then
		return tostring(n1-n2)
	else
		logo_bad_input("difference", n1, n2)
	end
end

subroutine.quotient		=	{p=2}
subroutine.quotient.func	=	function (_, n1, n2)
	if tonumber(n1) and tonumber(n2) then
		return tostring(n1/n2)
	else
		logo_bad_input("quotient", n1, n2)
	end
end

subroutine.modus		=	{p=2}
subroutine.modus.func	=	function (_, n1, n2)
	if tonumber(n1) and tonumber(n2) then
		return tostring(n1%n2)
	else
		logo_bad_input("modus", n1, n2)
	end
end

subroutine.remainder		=	{p=2}
subroutine.remainder.func	=	function (_, n1, n2)
	n1 = tonumber(n1)
	n2 = tonumber(n2)
	if n1 and n2 then
		n = n1%n2
		return tostring(n1<0 and (n<0 and n or -n) or (n<0 and -n or n))
	else
		logo_bad_input("remainer", n1, n2)
	end
end

subroutine.minus		=	{p=1}
subroutine.minus.func	=	function (_, n)
	if tonumber(n) then
		return tostring(-n)
	else
		logo_bad_input("minus", n)
	end
end

subroutine.sin	=	{p=1}
subroutine.sin.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.sin(math.rad(n)))
	else
		logo_bad_input("sin", n)
	end

end

subroutine.cos	=	{p=1}
subroutine.cos.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.cos(math.rad(n)))
	else
		logo_bad_input("cos", n)
	end

end

subroutine.tan	=	{p=1}
subroutine.tan.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.tan(math.rad(n)))
	else
		logo_bad_input("tan", n)
	end

end

subroutine.sqrt	=	{p=1}
subroutine.sqrt.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.sqrt(n))
	else
		logo_bad_input("sqrt", n)
	end

end

subroutine.power	=	{p=2}
subroutine.power.func	=	function (_, n, p)
	if tonumber(n) and tonumber(p) then
		return 	tostring(math.pow(n,p))
	else
		logo_bad_input("power", n, p)
	end

end

subroutine.log10	=	{p=1}
subroutine.log10.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.log10(n))
	else
		logo_bad_input("log10", n)
	end

end

subroutine.random	=	{p=1}
subroutine.random.func	=	function (_, n)
	if tonumber(n) then
		return 	tostring(math.random(n) - 1)
	else
		logo_bad_input("random", n)
	end	
end

subroutine.round	=	{p=1}
subroutine.round.func	=	function(_,n )
	if tonumber(n) then
		return tostring(math.floor(n+.5))
	else
		logo_bad_input("round", n)
	end
end

subroutine.int		=	{p=1}
subroutine.int.func	=	function(_,n)
	if tonumber(n) then
		return tostring(math.floor(n))
	else
		logo_bad_input("int", n)
	end		
end

--------------------------------------
--         Language routines        --
--------------------------------------


subroutine.make		=	{p=2}
subroutine.make.func	=	function(stack, name, content)
	for _,cstack in pairs(stack) do
		if cstack[name] then
			cstack[name] = content
			return
		end
	end
	
	global_stack[name] = content
end

subroutine["local"]		=	{p=1}
subroutine["local"].func	=	function(stack, name)
	if type(name) == "string" then
		stack[1][name]	=	""
	else
		logo_bad_input("local", name)
	end
end

subroutine.thing		=	{p=1}
subroutine.thing.func	=	function(stack, name)
	for _,cstack in pairs(stack) do
		if cstack[name] then
			return cstack[name]
		end
	end
	
	logo_error(cstack[name] .. " has no value")
end

subroutine["if"]	=	{p=2}
subroutine["if"].func	=	function(stack, bool, oper)
	__run	=	true
	local ret
	
	if type(oper) == "string" then oper = {oper} end
	
	if bool == "true" then
		local tack	=	{{}, unpack(stack)}
		local data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
	end
end

subroutine["ifelse"]	=	{p=3}
subroutine["ifelse"].func	=	function(stack, bool, oper1, oper2)
	__run	=	true
	local torun = {}
	local ret
	
	if type(oper1) == "string" then oper1 = {oper1} end
	
	if type(oper2) == "string" then oper2 = {oper2} end
	
	if bool == "true" then
		torun = oper1
	else
		torun = oper2
	end
	
	local tack	=	{{}, unpack(stack)}
	local data	=	{pos=1, token=torun}
	
	while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
		data.pos	=	data.pos + 1
	end
end


subroutine["repeat"]=	{p=2}
subroutine["repeat"].func	=	function(stack, n, oper)
	__run	=	true
	if type(oper) == "string" then oper = {oper} end
	
	if not tonumber(n) then logo_bad_input("repeat", n) end
	local tack	=	{{_repcount = 0}, unpack(stack)}
	local data	=	nil
	local ret
	
	for _i=1, n do
		tack[1]._repcount = _i
		data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
		if not __run then return end
	end
end

subroutine["do.while"]=	{p=2}
subroutine["do.while"].func	=	function(stack, oper, test)
	__run	=	true
	if type(oper) == "string" then oper = {oper} end
	if type(test) == "string" then test = {test} end
	
	local tack	=	{{}, unpack(stack)}
	local data	=	nil
	local ret	=	"true"
	
	while ret	==	"true" do
		data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
		
		ret	=	parse_token({pos=1, token=test}, tack)
		if ret	==	nil then
			logo_error(list_to_string(test) .. " did not output to do.while")
		end
		if not __run then return end
	
	end
end

subroutine["do.until"]=	{p=2}
subroutine["do.until"].func	=	function(stack, oper, test)
	__run	=	true
	if type(oper) == "string" then oper = {oper} end
	if type(test) == "string" then test = {test} end
	
	local tack	=	{{}, unpack(stack)}
	local data	=	nil
	local ret	=	"false"
	
	while ret	~=	"true" do
		data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
		
		ret	=	parse_token({pos=1, token=test}, tack)
		if ret	==	nil then
			logo_error(list_to_string(test) .. " did not output to do.until")
		end
		if not __run then return end
	
	end
end







subroutine["while"]=	{p=2}
subroutine["while"].func	=	function(stack, test, oper)
	__run	=	true
	if type(oper) == "string" then oper = {oper} end
	if type(test) == "string" then test = {test} end
	
	local tack	=	{{}, unpack(stack)}
	local data	=	nil
	local ret	=	parse_token({pos=1, token=test}, tack)
	if ret	==	nil then
		logo_error(list_to_string(test) .. " did not output to while")
	end
		
	while ret	==	"true" do
		data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
		
		ret	=	parse_token({pos=1, token=test}, tack)
		if ret	==	nil then
			logo_error(list_to_string(test) .. " did not output to while")
		end
		if not __run then return end
	
	end
end

subroutine["until"]=	{p=2}
subroutine["until"].func	=	function(stack, test, oper)
	__run	=	true
	if type(oper) == "string" then oper = {oper} end
	if type(test) == "string" then test = {test} end
	
	local tack	=	{{}, unpack(stack)}
	local data	=	nil
	local ret	=	parse_token({pos=1, token=test}, tack)
	if ret	==	nil then
		logo_error(list_to_string(test) .. " did not output to until")
	end
		
	while ret	~=	"true" do
		data	=	{pos=1, token=oper}
		
		while data.pos<=#data.token and __run do
			ret	=	parse_token(data, tack)
			if ret then 
				logo_bad_input("You don\'t say what to do with " .. ret)
			end
			data.pos	=	data.pos + 1
		end
		
		ret	=	parse_token({pos=1, token=test}, tack)
		if ret	==	nil then
			logo_error(list_to_string(test) .. " did not output to until")
		end
		if not __run then return end
	
	end
end


subroutine["for"]	=	{p=2}
subroutine["for"].func	=	function (_, control, oper)
	local varname
	local start
	local stop
	local step
	local data
	
	if type(control) == "table" then
		varname	=	control[1]
		if #control<3 then
			logo_bad_input("for", control)
		end
		
		--if type(control[2]) == "string" then control[2]	=	{control[2]} end
		--if type(control[3]) == "string" then control[3]	=	{control[3]} end
		--if type(control[4]) == "string" then control[4]	=	{control[4]} end
		
		local d	=	{pos=2, token=control}
		start	=	tonumber(parse_token(d, _))
		if d.pos >= #control then logo_bad_input("for", control) end
		d.pos	=	d.pos + 1
		stop	=	tonumber(parse_token(d, _))

		if d.pos<#control then
			d.pos	=	d.pos + 1
			step	=	tonumber(parse_token(d, _))
		else
			step	=	1
		end
		
		if not (type(varname) == "string" and start and stop and step) then
			logo_bad_input("for", control)
		end
		
		if type(oper) == "string" then oper = {oper} end
	
		local tack	=	{{}, unpack(_)}
		local ret	=	""
		__run	=	true
		
		for _i=start, stop, step do
			data	=	{pos=1, token=oper}
			tack[1][varname]	=	tostring(_i)
			while data.pos<=#data.token and __run do
				ret	=	parse_token(data, tack)
				if ret then 
					logo_bad_input("You don\'t say what to do with " .. ret)
				end
				data.pos	=	data.pos + 1
			end
			if not __run then return end
		end		
		
	else
		logo_bad_input("for", control)
	end
end

subroutine["output"]=	{p=1}
subroutine["output"].func	=	function(stack, outp)
	stack[1]["__output"] = outp
	__run	=	false
end


subroutine.stop		=	{p=0}
subroutine.stop.func	=	function(stack)
	__run	=	false
end


subroutine.repcount	=	{p=0}
subroutine.repcount.func	=	function (stack)
	if stack[1]._repcount then
		return tostring(stack[1]._repcount)
	else
		return tostring(-1)
	end
end



--------------------------------
--- Data Structure Primitives --
--------------------------------

subroutine.word		=	{p=2, e=true}
subroutine.word.func	=	function (_, ...)
	local output = ""
	for i,p in pairs{...} do
		if type(p)=="string" then
			output = output .. p .. " "
		else
			logo_bad_input("word", p)
		end
	end
	
	return output
end

subroutine.list	=	{p=2, e=true}
subroutine.list.func	=	function (_, ...)
	local l = {}
	for _, d in pairs{...} do
		table.insert(l, d)
	end
	
	return l
end

subroutine.sentence	=	{p=2, e=true}
subroutine.se = subroutine.sentence
subroutine.sentence.func	=	function (_, ...)
	local l = {}
	for _, d in pairs{...} do
		if type(d) == "string" then
			table.insert(l, d)
		else
			for _, w in pairs(d) do
				table.insert(l, w)
			end
		end
	end
	
	return l
end

subroutine.fput	=	{p=2}
subroutine.fput.func	=	function (_, thing, datum)
	if type(datum) == "string" then
		if type(thing) == "string" and #thing == 1 then
			return thing .. datum
		else
			logo_bad_input("fput", datum)
		end
	else
		local out	= {}
		
		table.insert(out, thing)
		
		for _,c in pairs(datum) do
			table.insert(out, c)
		end
	
		return out
	end
end

subroutine.lput	=	{p=2}
subroutine.lput.func	=	function (_, thing, datum)
	if type(datum) == "string" then
		if type(thing) == "string" and #thing == 1 then
			return thing .. datum
		else
			logo_bad_input("fput", datum)
		end
	else
		local out	= {}
		
		for _,c in pairs(datum) do
			table.insert(out, c)
		end
				
		table.insert(out, thing)
	
		return out
	end
end

subroutine.combine	=	{p=2}
subroutine.combine.func	=	function (_, thing1, thing2)
	if type(thing2) == "string" then
		return subroutine.word.func(_, thing1, thing2)
	else
		return subroutine.fput.func(_, thing1, thing2)
	end
end

subroutine.first	=	{p=1}
subroutine.first.func	=	function(_, datum)
	if type(datum) == "string" then
		return datum:sub(1, 1)
	else
		return datum[1]
	end
end

subroutine.last	=	{p=1}
subroutine.last.func	=	function(_, datum)
	if type(datum) == "string" then
		return datum:sub(-1)
	else
		return datum[#datum]
	end
end

subroutine.firsts	=	{p=1}
subroutine.firsts.func	=	function (_, datum) 
	if type(datum) == "table" and #datum>0 then
		out	=	{}
		for i,p in pairs(datum) do
			table.insert(out, subroutine.first.func(_, p))
		end
		return out
	else
		logo_bad_input("firsts", datum)
	end
end

subroutine.lasts	=	{p=1}
subroutine.lasts.func	=	function (_, datum) 
	if type(datum) == "table" and #datum>0 then
		out	=	{}
		for i,p in pairs(datum) do
			table.insert(out, subroutine.last.func(_, p))
		end
		return out
	else
		logo_bad_input("lasts", datum)
	end
end

subroutine.butfirst	=	{p=1}
subroutine.butfirst.func	=	function (_, datum)
	if #datum==0 then logo_bad_input("butfirst", datum) end
	if type(datum) == "string" then
		return datum:sub(2,-1)
	else
		local out = {}
		for i=2, #datum do 
			table.insert(out, datum[i])
		end
		return out
	end
end

subroutine.butfirsts	=	{p=1}
subroutine.butfirsts.func	=	function (_, datum) 
	if type(datum) == "table" and #datum>0 then
		out	=	{}
		for i,p in pairs(datum) do
			table.insert(out, subroutine.butfirst.func(_, p))
		end
		return out
	else
		logo_bad_input("butfirsts", datum)
	end
end

subroutine.butlast	=	{p=1}
subroutine.butlast.func	=	function (_, datum)
	if #datum==0 then logo_bad_input("butfirst", datum) end
	if type(datum) == "string" then
		return datum:sub(1,-2)
	else
		local out = {}
		for i=1, #datum-1 do 
			table.insert(out, datum[i])
		end
		return out
	end
end

subroutine.butlasts	=	{p=1}
subroutine.butlasts.func	=	function (_, datum) 
	if type(datum) == "table" and #datum>0 then
		out	=	{}
		for i,p in pairs(datum) do
			table.insert(out, subroutine.butlast.func(_, p))
		end
		return out
	else
		logo_bad_input("butfirsts", datum)
	end
end

subroutine.item	=	{p=2}
subroutine.item.func	=	function(_, index, datum)
	if index>#datum then logo_bad_input("item", index) end
	if type(datum) == "string" then
		return datum:sub(index,index)
	else
		return datum[index]
	end
end	

subroutine.pick	=	{p=1}
subroutine.pick.func	=	function(_, datum)
	local index = math.random(#datum)
	if type(datum) == "string" then
		return datum:sub(index,index)
	else
		return datum[index]
	end
end	

subroutine.remove	=	{p=2}
subroutine.remove.func	=	function (_, thing, datum)
	if type(datum) == "table" then
		local out = {}
		for i, p in pairs(datum) do
			if thing ~= p then
				table.insert(out, p)
			end
		end
		return out
	else
		logo_bad_input("remove", datum)
	end
end

subroutine.wordp	=	{p=1}
subroutine["word?"]	=	subroutine.wordp
subroutine.wordp.func	=	function(_, datum)
	if type(datum) == "string" then
		return "true"
	else
		return "false"
	end
end	

subroutine.listp	=	{p=1}
subroutine["list?"]	=	subroutine.listp
subroutine.listp.func	=	function(_, datum)
	if type(datum) == "table" then
		return "true"
	else
		return "false"
	end
end	

subroutine.numberp	=	{p=1}
subroutine["number?"]	=	subroutine.numberp
subroutine.numberp.func	=	function(_, datum)
	if tonumber(datum) then
		return "true"
	else
		return "false"
	end
end	

subroutine.emptyp	=	{p=1}
subroutine["empty?"]	=	subroutine.emptyp
subroutine.emptyp.func	=	function(_, datum)
	if #datum==0 then
		return "true"
	else
		return "false"
	end
end	

subroutine.equalp	=	{p=2}
subroutine["equal?"]	=	subroutine.equalp
subroutine.equalp.func	=	function(_, d1, d2)
	if d1 == d2 then
		return "true"
	else
		return "false"
	end
end	

subroutine.notequalp	=	{p=2}
subroutine["notequal?"]	=	subroutine.notequalp
subroutine.notequalp.func	=	function(_, d1, d2)
	if d1 ~= d2 then
		return "true"
	else
		return "false"
	end
end	

-----------------------------------------------------------------------------------------------
--------------------------------- Platform dependent routines ---------------------------------
-----------------------------------------------------------------------------------------------



----------------------------------
--         Print Routines       --
----------------------------------

subroutine.print	=	{p=1, e=true}
subroutine.print.func = function (_, ...)
	local out = ""
	for _,item in pairs({...}) do
		out = out .. list_to_string(item) .. " "
	end
	print(out)
end

subroutine.show	=	{p=1, e=true}
subroutine.show.func = function (_, ...)
	local out = ""
	for _,item in pairs({...}) do
		out = list_to_string(item, true)
	end
	print(out)
end

subroutine.debug	=	{p=1}
subroutine.debug.func = function (_, inp)
	print(inp)
	return inp
end


-------------------------------
--      Turtle routines      --
-------------------------------

turtle_colors	=	{}

turtle_colors["black"]	=	{0,0,0}
turtle_colors["0"]		=	{0,0,0}
turtle_colors["blue"]	=	{0,0,255}
turtle_colors["1"]		=	{0,0,255}
turtle_colors["green"]	=	{0,255,0}
turtle_colors["2"]		=	{0,255,0}
turtle_colors["cyan"]	=	{0,255,255}
turtle_colors["3"]		=	{0,255,255}
turtle_colors["red"]	=	{255,0,0}
turtle_colors["4"]		=	{255,0,0}
turtle_colors["magenta"]=	{246,100,175}
turtle_colors["5"]		=	{246,100,175}
turtle_colors["yellow"]	=	{252,232,131}
turtle_colors["6"]		=	{252,232,131}
turtle_colors["white"]	=	{255,255,255}
turtle_colors["7"]		=	{255,255,255}
turtle_colors["brown"]	=	{180,103,77}
turtle_colors["8"]		=	{180,103,77}
turtle_colors["tan"]	=	{250,167,108}
turtle_colors["9"]		=	{250,167,108}
turtle_colors["forest"]	=	{109,174,129}
turtle_colors["10"]		=	{109,174,129}
turtle_colors["aqua"]	=	{120,219,226}
turtle_colors["11"]		=	{120,219,226}
turtle_colors["salmon"]	=	{255,155,170}
turtle_colors["12"]		=	{255,155,170}
turtle_colors["purple"]	=	{255,29,206}
turtle_colors["13"]		=	{255,29,206}
turtle_colors["orange"]	=	{255,117,56}
turtle_colors["14"]		=	{255,117,56}
turtle_colors["grey"]	=	{127,127,127}
turtle_colors["15"]		=	{127,127,127}


subroutine.left		=	{p=1}
subroutine.lt		=	subroutine.left
subroutine.left.func = function (_, a)
	t:rotateTurtle(a)
end

subroutine.forward	=	{p=1}
subroutine.fd		=	subroutine.forward
subroutine.forward.func = function (_, l)
	t:moveForward(l)
end

subroutine.right	=	{p=1}
subroutine.rt		=	subroutine.right
subroutine.right.func = function (_, a)
	t:rotateTurtle(-a)
end

subroutine.back		=	{p=1}
subroutine.bk		=	subroutine.back
subroutine.back.func = function (_, l)
	t:moveForward(-l)
end

subroutine.circle	=	{p=1}
subroutine.circle.func	=	function (_, s)
	t:circle(s)
end 

subroutine.pendown		=	{p=0}
subroutine.pd		=	subroutine.pendown
subroutine.pd.func = function (_)
	t:penDown()
end

subroutine.penup	=	{p=0}
subroutine.pu		=	subroutine.penup
subroutine.pu.func = function (_)
	t:penUp()
end

subroutine.hideturtle	=	{p=0}
subroutine.ht		=	subroutine.hideturtle
subroutine.ht.func = function (_)
	--hide
end

subroutine.showturtle	=	{p=0}
subroutine.st		=	subroutine.showturtle
subroutine.showturtle.func = function (_)
	--show
end

subroutine.setx	=	{p=1}
subroutine.setx.func = function (_,x)
	t:setxy(x)
end

subroutine.sety	=	{p=1}
subroutine.sety.func = function (_,y)
	t:setxy(t.x,y)
end

subroutine.setxy	=	{p=2}
subroutine.setxy.func = function (_,x, y)
	t:setxy(x,y)
end

subroutine.label	=	{p=1}
subroutine.label.func = function (_,str)
	str	=	list_to_string(str,true)
	t.gc:drawString(str, t.x+t.homex, t.y+t.homey, "baseline")
end

subroutine.setlabelheight	=	{p=1}
subroutine.setlabelheight.func = function (_,n)
	n	=	tonumber(n)
	if n then
		t.gc:setFont("sansserif", "r", n)
	else
		logo_bad_input("setlabelheight", n)
	end
end

subroutine.ycor	=	{p=0}
subroutine.ycor.func = function (_)
	return	tostring(t.y)
end

subroutine.xcor	=	{p=0}
subroutine.xcor.func = function (_)
	return	tostring(t.x)
end

subroutine.pos	=	{p=0}
subroutine.pos.func = function (_)
	return	{tostring(t.x), tostring(t.y)}
end

subroutine.heading	=	{p=0}
subroutine.heading.func = function (_)
	return	tostring(t.angle)
end

subroutine.setheading	=	{p=1}
subroutine.setheading.func = function (_, a)
	if tonumber(a) then
		t.angle = a
	else
		logo_bad_input("setheading", a)
	end
end

subroutine.clean	=	{p=0}
subroutine.cs		=	subroutine.clean
subroutine.cg		=	subroutine.clean
subroutine.clean.func = function (_)
	--show
end

subroutine.setpencolor	=	{p=1}
subroutine.setpc		=	subroutine.setpencolor
subroutine.setc			=	subroutine.setpencolor
subroutine.setpencolor.func = function (_, color)
	if type(color) == "table" then
		local r	=	tonumber(color[1])
		local g	=	tonumber(color[1])
		local b	=	tonumber(color[1])
		if r and g and b then
			t:setColor(r, g, b)
		else
			logo_bad_input("setpencolor", color)
		end
	else
		local ccolor	=	turtle_colors[color]
		if ccolor then
			t:setColor(unpack(ccolor))
		else
			logo_bad_input("setpencolor", color)
		end
	end
end


