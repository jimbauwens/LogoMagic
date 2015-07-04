Editor_Main	=	Screen()
Editor_Main.top	=	1
Editor_Main.selected	=	1



se = string.uchar(233)
sa = string.uchar(224)
locale_strings = {}
locale_strings["fr"] = {"S"..se.."lectionnez le script logo pour modifier:", "Entrez le nom du script"}
locale_strings["en"] = {"Select logo script to edit:", "Enter the name of the script"} 
locale_strings["s"] = (locale.name() == "fr") and locale_strings["fr"] or locale_strings["en"]


function Editor_Main.paint(gc)
	local width, height	=	get_screen_size()
	local top		=	Editor_Main.top
	local selected	=	Editor_Main.selected
	Editor_Main.files	=	{"New script...", unpack(get_logo_files())}
	local files	=	Editor_Main.files
	local nfiles=	#files
	local bcolor
	Editor_Main.ditems		=	math.floor((height-60)/18)
	local ditems	=	Editor_Main.ditems
		
	gc:setColorRGB(200,200,200)
	gc:fillRect(0,0,width, height)
	
	gc:setColorRGB(0, 0, 0)
	gc:setFont("sansserif", "b", 11)
	gc:drawString("LogoMagic Script Editor", 2,2, "top")
	gc:setFont("sansserif", "b", 8)
	gc:fillRect(0, 27, width, 4)
	gc:drawRect(10, 50, width - 20, ditems*18 + 1)
	gc:drawString(locale_strings["s"][1],10, 35, "top")
	
	gc:setFont("sansserif", "r", 12)

	
	for i=1, math.min(nfiles, ditems) do
		bcolor	=	((i+top)%2==0) and {160,160,160} or {200,200,200}
		gc:setColorRGB(unpack(bcolor))
		if i+top-1 == selected then
			gc:setColorRGB(40,40,40)
		end
		gc:fillRect(11, 19+32+i*18-18, width-21, 18)
		gc:setColorRGB(0, 0, 0)
		if i+top-1 == selected then
			gc:setColorRGB(220,220,220)
		end
		gc:drawString(files[i+top-1], 15, 19+29+i*18-18, "top")
	end
	
	gc:setColorRGB(0,0,0)
	local selp	=	math.max((nfiles/ditems),1)
	gc:fillRect(width-5, 49 + ((top-1)*18+2)/selp, 3, (ditems*18+2)/selp +1)
end

function Editor_Main.arrowUp()
	if Editor_Main.selected>1 then
		Editor_Main.selected = Editor_Main.selected - 1
		if Editor_Main.top>Editor_Main.selected then
			Editor_Main.top = Editor_Main.top -1
		end
	end
	platform.window:invalidate()
end

function Editor_Main.arrowDown()
	if Editor_Main.selected<#Editor_Main.files then
		Editor_Main.selected = Editor_Main.selected + 1
		if Editor_Main.selected>Editor_Main.ditems+Editor_Main.top-1 then
			Editor_Main.top = Editor_Main.top +1
		end
	end
	platform.window:invalidate()
end

function Editor_Main.enterKey()
	if Editor_Main.selected == 1 then
		push_screen(Name)
		platform.window:invalidate()
	else
		filename	=	Editor_Main.files[Editor_Main.selected]
		Editor.text	=	get_logo_script(filename) .. "|"
		Editor.cursor = #Editor.text
		remove_screen()
		push_screen(Editor)
		platform.window:invalidate()
	end
end

Editor	=	Screen()

function Editor.paint(gc)
	local width, height	=	get_screen_size()
	

	gc:setColorRGB(200,200,200)
	gc:fillRect(0,0,width, height)
	
	gc:setColorRGB(0, 0, 0)
	gc:setFont("sansserif","b",10)
	gc:drawString(filename, 2, -2, "top")
	
	gc:fillRect(0, 14, width, 4)
	gc:setFont("sansserif","r",10)
	
	Editor.lines	=	Editor.text:split("\n")
	local lines	=	Editor.lines

	local pos	=	1
	local ll	=	0
	for _ in Editor.text:sub(1, Editor.cursor):gmatch("\n") do 
		ll = ll + 1 
		pos = pos + math.max(math.ceil(gc:getStringWidth(lines[ll])/(width-5)) ,1)
	end	
	
	local oline	=	""
	local linepos	=	0
	local linepossible = math.floor((height-20)/14)-1
	local start	=	1
	if pos>linepossible then
		start = pos-linepossible+1
	end
	
	for ln=start,#lines do
		local line = lines[ln]
		linepos = linepos + 1
		oline	=	""
		words	=	line:split(" ")
		for wi_, word in pairs(words) do
			if gc:getStringWidth(oline .. word) < width-5 then 
				oline	=	oline .. word .. " "
			else
				gc:drawString(oline, 2, 20 + linepos*14-14, "top")
				linepos = linepos + 1
				oline = word .. " "
			end
		end
		gc:drawString(oline, 2, 20 + linepos*14-14, "top")
	end
end

function Editor.charIn(ch)
	local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
	local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
	
	Editor.text	=	pretext .. ch .. "|" .. afttext
	Editor.cursor = #pretext + #ch + 1
	platform.window:invalidate()
end


function Editor.enterKey()
	local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
	local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
	
	Editor.text	=	pretext .. "\n" .. "|" .. afttext
	Editor.cursor = #pretext + 2
	platform.window:invalidate()
end

function Editor.tabKey()
	local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
	local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
	
	Editor.text	=	pretext .. "    " .. "|" .. afttext
	Editor.cursor = #pretext + 5
	platform.window:invalidate()
end

function Editor.arrowLeft()
	if Editor.cursor>1 then
		local pretext	=	Editor.text:sub(1, Editor.cursor - 2)
		local char		=	Editor.text:sub(Editor.cursor-1, Editor.cursor - 1)
		local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
		
		Editor.text	=	pretext .. "|" .. char .. afttext
		Editor.cursor = #pretext + 1
		platform.window:invalidate()
	end
end

function Editor.arrowRight()
	if Editor.cursor<#Editor.text then
		local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
		local char		=	Editor.text:sub(Editor.cursor+1, Editor.cursor +1)
		local afttext	=	Editor.text:sub(Editor.cursor + 2, -1)
		
		Editor.text	=	pretext .. char .. "|" .. afttext
		Editor.cursor = #pretext + 2
		platform.window:invalidate()
	end
end

function Editor.arrowUp()
	local pos	=	0
	for _ in Editor.text:sub(1, Editor.cursor):gmatch("\n") do pos = pos + 1 end
	if pos>0 then
		local lline	=	#Editor.lines[pos]
		local cline	=	0
		while true do
			if Editor.text:sub(Editor.cursor-1-cline, Editor.cursor-1-cline)  == "\n" then break end
			cline = cline + 1
		end
		lline	=	math.max(lline, cline)
		
		local pretext	=	Editor.text:sub(1, Editor.cursor - lline - 2)
		local midtext		=	Editor.text:sub(Editor.cursor - lline-1, Editor.cursor - 1)
		local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
		
		Editor.text	=	pretext .. "|" .. midtext .. afttext
		Editor.cursor = #pretext + 1
		platform.window:invalidate()	
	end
end

function Editor.arrowDown()
	local pos	=	0
	for _ in Editor.text:sub(1, Editor.cursor):gmatch("\n") do pos = pos + 1 end
	if pos<#Editor.lines then
		local nline	=	0

		while true do
			nline = nline + 1
			if Editor.text:sub(Editor.cursor+nline, Editor.cursor+nline)  == "\n" then break end
			if Editor.cursor+nline>#Editor.text then return end
		end		
				
		local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
		local midtext	=	Editor.text:sub(Editor.cursor + 1, Editor.cursor+nline)
		local afttext	=	Editor.text:sub(Editor.cursor+nline+1, -1)
		
		Editor.text	=	pretext .. midtext .. "|" .. afttext
		Editor.cursor = Editor.cursor+nline 
		platform.window:invalidate()	
	else
		local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
		local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
		Editor.text	=	pretext .. afttext .. "|"
		Editor.cursor	=	#Editor.text
	end
end

function Editor.backspaceKey()
	if Editor.cursor>1 then
		local pretext	=	Editor.text:sub(1, Editor.cursor - 2)
		local char		=	Editor.text:sub(Editor.cursor-1, Editor.cursor - 1)
		local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
		
		Editor.text	=	pretext .. "|" .. afttext
		Editor.cursor = #pretext + 1
		platform.window:invalidate()
	end
end

function Editor.escapeKey()
	local pretext	=	Editor.text:sub(1, Editor.cursor - 1)
	local afttext	=	Editor.text:sub(Editor.cursor + 1, -1)
	store_logo_script(filename, pretext .. afttext)
	remove_screen()
	push_screen(Editor_Main)
	platform.window:invalidate()
end

function drawStringMiddle(gc, tstring, y)
	local width =	get_screen_size()
	local w = gc:getStringWidth(tstring)
	gc:drawString(tstring, (width/2)-(w/2), y, "top")
end

Name = Screen()
Name.text	=	""

function Name.paint(gc)
	local width, height	=	get_screen_size()
	gc:setFont("sansserif","r",8)
	gc:setColorRGB(150,150,150)
	gc:fillRect(35,height/2-20,width-70, 40)
	gc:setPen("medium","smooth")
	gc:setColorRGB(0,0,0)
	gc:drawRect(35,height/2-20,width-70, 40)
	
	drawStringMiddle(gc,locale_strings["s"][2], height/2-18)
	gc:setPen("thin","smooth")
	gc:drawRect(40,height/2-4,width-80, 20)
	gc:drawString(Name.text,42,height/2-1, "top")
end

function Name.charIn(ch)
	Name.text = Name.text .. ch
	platform.window:invalidate()
end

function Name.backspaceKey()
	Name.text = Name.text:sub(1,-2)
	platform.window:invalidate()
end

function Name.enterKey()
	filename	=	Name.text
	Screens		=	{Editor}
	Editor.text	=	"|"
	Editor.cursor = 1
	platform.window:invalidate()
end

push_screen(Editor_Main)
