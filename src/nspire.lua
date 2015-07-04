function get_screen_size()
	local window	=	platform.window
	return window:width(), window:height()
end

function get_logo_files()
	return var.list()
	
end

function get_logo_script(nam)
	return var.recallstr(nam):sub(2,-2):gsub("\"\"","\""):gsub("\039","\"")
end

function store_logo_script(nam, data)
	var.store(nam, data:gsub("\"","\039"))
end
