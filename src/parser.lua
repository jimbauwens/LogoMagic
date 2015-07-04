
function logo_error(err)
	error(err,0)
end

function justWords(str)
  local t = {}
  for w in str:gmatch("%S+") do table.insert(t, w) end
  return t
end 

function run(lgo)
	local lgo=justWords(lgo:gsub("[*%/-+()<>=%[%]]"," %1 "):gsub(">  =",">="):gsub("<  =", "<="):gsub("<  >", "<>"))	local d={pos=1, token=lgo}
	local ret
	
	global_stack = {}
	while d.pos<=#d.token do
		ret = parse_token(d, {global_stack})
		if ret then 
			logo_error("You don\'t say what to do with " .. ret)
		end
		d.pos=d.pos+1
	end
end

function data_type(d, stack, pre)
	
	local pretoken	= {}
	pretoken[d.pos]	= pre
	
	local token		=	pretoken[d.pos] or d.token[d.pos]		-- The token
	local bf_token	=	token:sub(2)		-- Everything but the first character
	local bl_token	=	token:sub(1, 1)		-- The first character
	local content	=	""
	
	if bl_token == "\"" then				-- If self reference
		return bf_token, 0
	
	elseif bl_token == ":" then				-- If variable
		
		for _,cstack in pairs(stack) do
			content	=	cstack[bf_token]
			if content then return content, 0 end
		end
		
		logo_error(bf_token .. " has no value")
		
	elseif tonumber(token) then				-- If number 
		return token, 0
		
	elseif token == "[" then				-- If list
		return parse_list(d)
	end
	
end


------------------------------------------
--             PARSE TOKENS             --
------------------------------------------

function parse_token(d, stack, endl, busy_infix)
	local token		=	d.token[d.pos]		-- The token
	if type(token) == "table" then return token end
	local dt	=	data_type(d, stack)
	local ntoken	=	""
	local return_value	=	nil
	
	if dt then
		return_value = dt
	elseif token == "-" then
		--[[
		
		--]]
	elseif token == "(" then				-- Start a new parse instance if (
		d.pos = d.pos + 1
		return_value = parse_token(d, stack, true)
		
	elseif token:lower() == "to" then		-- If TO
		parse_to(d)
	elseif subroutine[token:lower()] then			-- If operation 

	
		local routine	=	subroutine[token:lower()]
		
		local nargs	=	routine.p
		local args	=	{}
		local i	=	0
		local retval	=	0
		
		while true do
			if i == nargs and not endl then
				break
			end
			
			i = i + 1
			d.pos	=	d.pos + 1	
			ntoken	=	d.token[d.pos]	
			
			if not ntoken then logo_error("not enough inputs to " .. token) end	
				
			if ntoken == ")" then break end
			retval	=	parse_token(d, stack)
			if not retval then
				logo_error(ntoken .. " didn't output to " .. token)
			end
			
				
			table.insert(args, retval)
			
			ntoken	=	d.token[d.pos]
			if ntoken == ")" then break end		
		end
		
		if routine.func then
			return_value =  routine.func(stack, unpack(args))	
		else
			__run	=	true
			local sub_stack = {}
			for i, parm in pairs(routine.pn) do
				sub_stack[parm] = args[i]
			end
			
			local data 	=	{pos=1, token=routine.routine}
			local tack	=	{sub_stack, unpack(stack)}
			
			while data.pos<=#data.token and __run do
				parse_token(data, tack)
				data.pos=data.pos+1
			end
			
			return_value = sub_stack["__output"]
			__run	=	true
		end
		
	else									-- If nothing of the above, error
		logo_error("I don\'t know how to " .. token)
	end

	if token=="-" or infix[d.token[d.pos+1]] and ntoken~=")" and not busy_infix then
		return compute_infix(d, stack, endl, return_value)
		
	else
		return return_value
	end			
	
end

----------------------------
--       PARSE LIST       --
----------------------------

function parse_list(d)
	local list	=	{}
	local token	=	""
	
	while true do
		d.pos = d.pos + 1
		token	=	d.token[d.pos]
		if token == "[" then
			token = parse_list(d)
		elseif token == "]"then
			break
		end
		
		table.insert(list, token)
	end
	return list
end

----------------------------
--        PARSE TO        --
----------------------------

function parse_to(d)
	d.pos = d.pos + 1
	
	local name	=	d.token[d.pos]:lower()
	local parm	=	nil
	local pref	=	nil
	local token	=	""
	
	if subroutine[name] then
		--logo_error(name .. " is already defined")
	end
	
	subroutine[name]	=	{}
	subroutine[name].p	=	0
	subroutine[name].pn	=	{}
	
	
	while true do
		d.pos	=	d.pos + 1
		parm	=	d.token[d.pos]
		pref	=	parm:sub(1,1)
		if pref == ":" then
			subroutine[name].p	=	subroutine[name].p + 1
			table.insert(subroutine[name].pn, parm:sub(2,-1))
		else
			break
		end	
	end
	
	subroutine[name].routine	=	{}
	
	while true do
		token	=	d.token[d.pos]
		if token ~= "end" then
			table.insert(subroutine[name].routine, token)
		else
			return
		end
		d.pos	=	d.pos + 1
	end
end

------------------
-- Clean output --
------------------


function list_to_string(d, q)
	if type(d) == "string" then return d end
	local out = ""
	for i,p in pairs(d) do
		if type(p) == "string" then
			out	=	out .. p .. " "
		else
			out	=	out .. "[ " .. list_to_string(p) .. "] "
		end
	end
	
	return q and "[ " .. out .. "]" or out
end


