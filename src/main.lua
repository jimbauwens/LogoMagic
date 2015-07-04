lgo = [[
make "a 1
make "b 10
make "c 2
for [i :a :b :c] [print :i]
]]
 
--[[
on={}
run(lgo)
--]]

se = string.uchar(233)
sa = string.uchar(224)
locale_strings = {}
locale_strings["fr"] = {"S"..se.."lectionnez le script logo "..sa.." ex"..se.."cuter:"}
locale_strings["en"] = {"Select logo script to run:"} 
locale_strings["s"] = (locale.name() == "fr") and locale_strings["fr"] or locale_strings["en"]


main	=	Screen()
main.top	=	1
main.selected	=	1

function main.paint(gc)
	local width, height	=	get_screen_size()
	local top		=	main.top
	local selected	=	main.selected
	main.files	=	get_logo_files()
	local files	=	main.files
	local nfiles=	#files
	local bcolor
	main.ditems		=	math.floor((height-60)/18)
	local ditems	=	main.ditems
		
	gc:setColorRGB(200,200,200)
	gc:fillRect(0,0,width, height)
	
	gc:setColorRGB(0, 0, 0)
	gc:setFont("sansserif", "b", 11)
	gc:drawString("LogoMagic v1.0", 2,2, "top")
	gc:setFont("sansserif", "b", 8)
	gc:drawString("by Jim Bauwens", 135,8, "top")	
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

function main.arrowUp()
	if main.selected>1 then
		main.selected = main.selected - 1
		if main.top>main.selected then
			main.top = main.top -1
		end
	end
	platform.window:invalidate()
end

function main.arrowDown()
	if main.selected<#main.files then
		main.selected = main.selected + 1
		if main.selected>main.ditems+main.top-1 then
			main.top = main.top +1
		end
	end
	platform.window:invalidate()
end

function main.enterKey()
	if #main.files>0 then
		filename	=	main.files[main.selected]
		remove_screen()
		push_screen(Logo)
		platform.window:invalidate()
	end
end


Logo = Screen()


push_screen(main)

function Logo.paint(gc)
	local width, height	=	get_screen_size()
	t	=	Turtle(gc, width/2, height/2)
	xpcall(lgo_run, print)
end

function lgo_run()
	run(get_logo_script(filename))
end

function Logo.escapeKey()
	remove_screen()
	push_screen(main)
	platform.window:invalidate()
end
