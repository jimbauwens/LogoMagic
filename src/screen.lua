--------------------------------------------------
-- Jim Bauwens implentation of a Screen manager --
-- Original Idea from Levak, so many credits to --
--                   him!                       --
--------------------------------------------------

Screen	=	class()
Screens	=	{}

function push_screen(screen)
	table.insert(Screens, screen)
end

function remove_screen(screen)
	return table.remove(Screens)
end

function current_screen()
	return Screens[#Screens]
end

function Screen:init()

end

function Screen.paint(gc)	end
function Screen.timer()		end
function Screen.arrowUp()	end
function Screen.arrowDown()	end
function Screen.arrowLeft()	end
function Screen.arrowRight()end
function Screen.enterKey()	end
function Screen.escapeKey()	end
function Screen.tabKey()	end
function Screen.charIn(char) end

function on.paint(gc)	current_screen().paint(gc)		end
function on.timer()		current_screen().timer()		end
function on.arrowUp()	current_screen().arrowUp()		end
function on.arrowDown()	current_screen().arrowDown()	end
function on.arrowLeft()	current_screen().arrowLeft()	end
function on.arrowRight()current_screen().arrowRight()	end
function on.enterKey()	current_screen().enterKey()		end
function on.escapeKey()	current_screen().escapeKey()	end
function on.tabKey()	current_screen().tabKey()		end
function on.charIn(ch) current_screen().charIn(ch)		end
function on.backspaceKey() current_screen().backspaceKey() end


